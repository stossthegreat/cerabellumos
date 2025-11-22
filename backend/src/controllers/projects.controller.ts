// backend/src/controllers/projects.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";

export async function projectsController(fastify: FastifyInstance) {
  /**
   * GET /projects - Get all projects
   */
  fastify.get("/projects", async (req: any) => {
    const userId = req.userId;

    const projects = await prisma.project.findMany({
      where: { userId },
      orderBy: { lastActive: "desc" },
      include: {
        messages: {
          take: 1,
          orderBy: { createdAt: "desc" },
        },
        _count: {
          select: { messages: true },
        },
      },
    });

    return { projects };
  });

  /**
   * POST /projects - Create new project
   */
  fastify.post("/projects", async (req: any) => {
    const userId = req.userId;
    const { name, emoji, description, pinned } = req.body;

    if (!name) {
      return { error: "name required" };
    }

    const project = await prisma.project.create({
      data: {
        userId,
        name,
        emoji: emoji || "📚",
        description,
        pinned: pinned || false,
      },
    });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "project_created",
        payload: { projectId: project.id, name },
      },
    });

    return { ok: true, project };
  });

  /**
   * GET /projects/:id - Get project details
   */
  fastify.get("/projects/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    const project = await prisma.project.findUnique({
      where: { id, userId },
      include: {
        _count: {
          select: { messages: true },
        },
      },
    });

    if (!project) {
      return { error: "Project not found" };
    }

    return { project };
  });

  /**
   * GET /projects/:id/messages - Get messages for a project
   */
  fastify.get("/projects/:id/messages", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { limit = 50 } = req.query as any;

    // Verify ownership
    const project = await prisma.project.findUnique({
      where: { id, userId },
    });

    if (!project) {
      return { error: "Project not found" };
    }

    const messages = await prisma.message.findMany({
      where: { projectId: id },
      orderBy: { createdAt: "asc" },
      take: limit,
    });

    return { messages };
  });

  /**
   * POST /projects/:id/message - Send message and get AI reply
   */
  fastify.post("/projects/:id/message", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { content } = req.body;

    if (!content) {
      return { error: "content required" };
    }

    // Verify ownership
    const project = await prisma.project.findUnique({
      where: { id, userId },
    });

    if (!project) {
      return { error: "Project not found" };
    }

    // Save user message
    const userMsg = await prisma.message.create({
      data: {
        projectId: id,
        role: "user",
        content,
      },
    });

    // Get conversation history
    const history = await prisma.message.findMany({
      where: { projectId: id },
      orderBy: { createdAt: "asc" },
      take: 20, // last 20 messages for context
    });

    // Generate AI response (using study consciousness)
    const aiResponse = await aiService.generateProjectReply(userId, content, history);

    // Save AI message
    const assistantMsg = await prisma.message.create({
      data: {
        projectId: id,
        role: "assistant",
        content: aiResponse,
      },
    });

    // Update project lastActive
    await prisma.project.update({
      where: { id },
      data: { lastActive: new Date() },
    });

    return {
      ok: true,
      userMessage: userMsg,
      aiMessage: assistantMsg,
    };
  });

  /**
   * PUT /projects/:id - Update project
   */
  fastify.put("/projects/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { name, emoji, description, pinned } = req.body;

    const project = await prisma.project.update({
      where: { id, userId },
      data: {
        ...(name && { name }),
        ...(emoji && { emoji }),
        ...(description !== undefined && { description }),
        ...(pinned !== undefined && { pinned }),
      },
    });

    return { ok: true, project };
  });

  /**
   * DELETE /projects/:id - Delete project
   */
  fastify.delete("/projects/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.project.delete({
      where: { id, userId },
    });

    return { ok: true };
  });
}

