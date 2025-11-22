// backend/src/controllers/intel.controller.ts
import { FastifyInstance } from "fastify";
import { aiService } from "../services/ai.service";
import { prisma } from "../utils/db";

export async function intelController(fastify: FastifyInstance) {
  /**
   * GET /intel/latest - Get latest daily Intel
   */
  fastify.get("/intel/latest", async (req: any) => {
    const userId = req.userId;

    const latest = await prisma.coachMessage.findFirst({
      where: {
        userId,
        kind: "intel" as any,
      },
      orderBy: { createdAt: "desc" },
    });

    if (!latest) {
      // Generate on-demand if none exists
      const intel = await aiService.generateDailyIntel(userId);
      return intel;
    }

    // Parse meta if it exists
    const meta = (latest.meta as any) || {};

    return {
      threatAssessment: meta.threatAssessment || latest.body.slice(0, 200),
      weaknesses: meta.weaknesses || [],
      predictions: meta.predictions || [],
      todaysMissions: meta.missions || [],
      insights: meta.insights || [],
      fullText: latest.body,
      createdAt: latest.createdAt,
    };
  });

  /**
   * POST /intel/regenerate - Force regenerate Intel
   */
  fastify.post("/intel/regenerate", async (req: any) => {
    const userId = req.userId;
    const intel = await aiService.generateDailyIntel(userId);
    return intel;
  });

  /**
   * GET /intel/history - Get Intel history
   */
  fastify.get("/intel/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 7 } = req.query as any;

    const history = await prisma.coachMessage.findMany({
      where: { userId, kind: "intel" as any },
      orderBy: { createdAt: "desc" },
      take: limit,
    });

    return { history };
  });
}

