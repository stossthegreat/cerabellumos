// backend/src/controllers/study-targets.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";

export async function studyTargetsController(fastify: FastifyInstance) {
  /**
   * POST /targets - Create study target (synced from Flutter)
   */
  fastify.post("/targets", async (req: any) => {
    const userId = req.userId;
    const { title, description, emoji, startDate, endDate } = req.body;

    if (!title || !startDate || !endDate) {
      return { error: "title, startDate, and endDate required" };
    }

    const target = await prisma.studyTarget.create({
      data: {
        userId,
        title,
        description,
        emoji: emoji || "🎯",
        startDate: new Date(startDate),
        endDate: new Date(endDate),
      },
    });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "target_created",
        payload: { targetId: target.id, title },
      },
    });

    return { ok: true, target };
  });

  /**
   * GET /targets - Get all study targets
   */
  fastify.get("/targets", async (req: any) => {
    const userId = req.userId;
    const { completed } = req.query as any;

    const where: any = { userId };
    if (completed !== undefined) where.completed = completed === "true";

    const targets = await prisma.studyTarget.findMany({
      where,
      orderBy: { createdAt: "desc" },
    });

    return { targets };
  });

  /**
   * POST /targets/:id/toggle - Toggle completion status
   */
  fastify.post("/targets/:id/toggle", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    const target = await prisma.studyTarget.findUnique({
      where: { id, userId },
    });

    if (!target) {
      return { error: "Target not found" };
    }

    const updated = await prisma.studyTarget.update({
      where: { id },
      data: {
        completed: !target.completed,
        completedAt: !target.completed ? new Date() : null,
      },
    });

    // Log event if completed
    if (updated.completed) {
      await prisma.event.create({
        data: {
          userId,
          type: "target_completed",
          payload: { targetId: id, title: target.title },
        },
      });
    }

    return { ok: true, target: updated };
  });

  /**
   * DELETE /targets/:id - Delete target
   */
  fastify.delete("/targets/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.studyTarget.delete({
      where: { id, userId },
    });

    return { ok: true };
  });

  /**
   * PUT /targets/:id - Update target
   */
  fastify.put("/targets/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { title, description, emoji, startDate, endDate } = req.body;

    const target = await prisma.studyTarget.update({
      where: { id, userId },
      data: {
        ...(title && { title }),
        ...(description !== undefined && { description }),
        ...(emoji && { emoji }),
        ...(startDate && { startDate: new Date(startDate) }),
        ...(endDate && { endDate: new Date(endDate) }),
      },
    });

    return { ok: true, target };
  });
}

