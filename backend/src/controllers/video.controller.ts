// backend/src/controllers/video.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";

export async function videoController(fastify: FastifyInstance) {
  /**
   * POST /video/summarize - Summarize video content
   */
  fastify.post("/video/summarize", async (req: any) => {
    const userId = req.userId;
    const { title, transcript, url } = req.body;

    if (!title || !transcript) {
      return { error: "title and transcript required" };
    }

    // AI summarizes
    const summary = await aiService.summarizeVideo(userId, transcript, title);

    // Save to database
    const saved = await prisma.videoSummary.create({
      data: {
        userId,
        title,
        url,
        subject: summary.subject,
        topic: summary.topic,
        transcript,
        summary: summary.summary,
        keyPoints: summary.keyPoints,
      },
    });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "video_summary",
        payload: {
          videoId: saved.id,
          title,
          subject: summary.subject,
          topic: summary.topic,
        },
      },
    });

    return {
      ok: true,
      summary: summary.summary,
      keyPoints: summary.keyPoints,
      concepts: summary.concepts,
      subject: summary.subject,
      topic: summary.topic,
      savedId: saved.id,
    };
  });

  /**
   * GET /video/history - Get video summary history
   */
  fastify.get("/video/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 20, saved } = req.query as any;

    const where: any = { userId };
    if (saved !== undefined) where.saved = saved === "true";

    const videos = await prisma.videoSummary.findMany({
      where,
      orderBy: { createdAt: "desc" },
      take: limit,
    });

    return { videos };
  });

  /**
   * GET /video/:id - Get specific video summary
   */
  fastify.get("/video/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    const video = await prisma.videoSummary.findUnique({
      where: { id, userId },
    });

    if (!video) {
      return { error: "Video not found" };
    }

    return { video };
  });

  /**
   * POST /video/:id/save - Toggle save status
   */
  fastify.post("/video/:id/save", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    const video = await prisma.videoSummary.findUnique({
      where: { id, userId },
    });

    if (!video) {
      return { error: "Video not found" };
    }

    const updated = await prisma.videoSummary.update({
      where: { id },
      data: { saved: !video.saved },
    });

    return { ok: true, video: updated };
  });

  /**
   * DELETE /video/:id - Delete video summary
   */
  fastify.delete("/video/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.videoSummary.delete({
      where: { id, userId },
    });

    return { ok: true };
  });
}

