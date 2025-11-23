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
  fastify.post("/projects/:id/message", async (req: any, reply: any) => {
    try {
      console.log(`📨 [PROJECTS] Received message for project ${req.params.id}`);
      console.log(`📨 [PROJECTS] User ID: ${req.userId}`);
      console.log(`📨 [PROJECTS] Content: ${req.body.content?.substring(0, 50)}...`);
      
      const userId = req.userId;
      const { id } = req.params;
      const { content } = req.body;

      if (!content) {
        console.error("❌ [PROJECTS] No content provided");
        return reply.code(400).send({ error: "content required" });
      }

      // Verify ownership
      const project = await prisma.project.findUnique({
        where: { id, userId },
      });

      if (!project) {
        console.error(`❌ [PROJECTS] Project ${id} not found for user ${userId}`);
        return reply.code(404).send({ error: "Project not found" });
      }

      console.log(`✅ [PROJECTS] Project found: ${project.name}`);

      // Save user message
      const userMsg = await prisma.message.create({
        data: {
          projectId: id,
          role: "user",
          content,
        },
      });

      console.log(`✅ [PROJECTS] User message saved`);

      // Get conversation history
      const history = await prisma.message.findMany({
        where: { projectId: id },
        orderBy: { createdAt: "asc" },
        take: 20, // last 20 messages for context
      });

      console.log(`✅ [PROJECTS] Loaded ${history.length} messages from history`);
      console.log(`🤖 [PROJECTS] Calling AI service...`);

      // Generate AI response (using study consciousness)
      const aiResponse = await aiService.generateProjectReply(userId, content, history);

      console.log(`✅ [PROJECTS] AI response received: ${aiResponse.substring(0, 50)}...`);

      // Save AI message
      const assistantMsg = await prisma.message.create({
        data: {
          projectId: id,
          role: "assistant",
          content: aiResponse,
        },
      });

      console.log(`✅ [PROJECTS] AI message saved`);

      // Update project lastActive
      await prisma.project.update({
        where: { id },
        data: { lastActive: new Date() },
      });

      console.log(`✅ [PROJECTS] Message flow complete`);

      return {
        ok: true,
        userMessage: userMsg,
        aiMessage: assistantMsg,
      };
    } catch (error: any) {
      console.error("❌ [PROJECTS] Error in message endpoint:", error);
      console.error("❌ [PROJECTS] Stack:", error.stack);
      return reply.code(500).send({ 
        error: "Internal server error", 
        message: error.message,
        details: process.env.NODE_ENV === 'development' ? error.stack : undefined
      });
    }
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

