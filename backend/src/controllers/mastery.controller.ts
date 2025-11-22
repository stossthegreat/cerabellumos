// backend/src/controllers/mastery.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";

export async function masteryController(fastify: FastifyInstance) {
  /**
   * GET /mastery - Get all topic mastery
   */
  fastify.get("/mastery", async (req: any) => {
    const userId = req.userId;
    const { subject } = req.query as any;

    const where: any = { userId };
    if (subject) where.subject = subject;

    const mastery = await prisma.topicMastery.findMany({
      where,
      orderBy: { score: "asc" }, // weakest first
    });

    return { mastery };
  });

  /**
   * POST /mastery/update - Update topic mastery manually
   */
  fastify.post("/mastery/update", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, score, confidence } = req.body;

    if (!subject || !topic || score === undefined) {
      return { error: "subject, topic, and score required" };
    }

    const updated = await prisma.topicMastery.upsert({
      where: {
        userId_subject_topic: { userId, subject, topic },
      },
      update: {
        score: Math.max(0, Math.min(100, score)),
        confidence: confidence !== undefined ? Math.max(0, Math.min(100, confidence)) : undefined,
        lastStudied: new Date(),
        updatedAt: new Date(),
      },
      create: {
        userId,
        subject,
        topic,
        score: Math.max(0, Math.min(100, score)),
        confidence: confidence || 50,
        lastStudied: new Date(),
      },
    });

    // Log event if milestone
    if (score >= 75) {
      await prisma.event.create({
        data: {
          userId,
          type: "topic_mastered",
          payload: { subject, topic, score },
        },
      });
    } else if (score < 50) {
      await prisma.event.create({
        data: {
          userId,
          type: "weakness_identified",
          payload: { subject, topic, score },
        },
      });
    }

    return { ok: true, mastery: updated };
  });

  /**
   * GET /mastery/weak - Get weak topics only
   */
  fastify.get("/mastery/weak", async (req: any) => {
    const userId = req.userId;

    const weak = await prisma.topicMastery.findMany({
      where: {
        userId,
        score: { lt: 50 },
      },
      orderBy: { score: "asc" },
    });

    return { weakTopics: weak };
  });

  /**
   * GET /mastery/strong - Get strong topics
   */
  fastify.get("/mastery/strong", async (req: any) => {
    const userId = req.userId;

    const strong = await prisma.topicMastery.findMany({
      where: {
        userId,
        score: { gte: 75 },
      },
      orderBy: { score: "desc" },
    });

    return { strongTopics: strong };
  });
}

