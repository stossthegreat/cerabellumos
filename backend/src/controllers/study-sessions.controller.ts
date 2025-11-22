// backend/src/controllers/study-sessions.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { semanticMemory } from "../services/semanticMemory.service";
import { studyIntelligence } from "../services/study-intelligence.service";
import { schedulerQueue } from "../jobs/scheduler";

export async function studySessionsController(fastify: FastifyInstance) {
  /**
   * POST /study/session - Log a study session
   */
  fastify.post("/study/session", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, minutes, effectiveness, notes } = req.body;

    if (!subject || !minutes) {
      return { error: "subject and minutes required" };
    }

    const session = await prisma.studySession.create({
      data: {
        userId,
        subject,
        topic,
        minutes,
        effectiveness,
        notes,
      },
    });

    // Trigger post-study analysis (async)
    schedulerQueue.add("analyze-session", { sessionId: session.id });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "study_session_complete",
        payload: { sessionId: session.id, subject, topic, minutes },
      },
    });

    // Store in semantic memory
    const memoryText = `Studied ${subject}${topic ? ` - ${topic}` : ""} for ${minutes} minutes${notes ? `. Notes: ${notes}` : ""}`;
    await semanticMemory.storeMemory({
      userId,
      type: "study_session" as any,
      text: memoryText,
      metadata: { subject, topic, minutes, sessionId: session.id },
      importance: 3,
    });

    return { ok: true, session };
  });

  /**
   * GET /study/sessions - Get recent sessions
   */
  fastify.get("/study/sessions", async (req: any) => {
    const userId = req.userId;
    const { limit = 20, subject } = req.query as any;

    const where: any = { userId };
    if (subject) where.subject = subject;

    const sessions = await prisma.studySession.findMany({
      where,
      orderBy: { createdAt: "desc" },
      take: limit,
    });

    return { sessions };
  });

  /**
   * GET /study/today - Get today's study progress
   */
  fastify.get("/study/today", async (req: any) => {
    const userId = req.userId;
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const sessions = await prisma.studySession.findMany({
      where: {
        userId,
        createdAt: { gte: today },
      },
    });

    const totalMinutes = sessions.reduce((sum, s) => sum + s.minutes, 0);
    const subjects = [...new Set(sessions.map((s) => s.subject))];

    return {
      minutes: totalMinutes,
      sessionsCount: sessions.length,
      subjects,
      sessions,
    };
  });

  /**
   * GET /study/stats - Get study statistics
   */
  fastify.get("/study/stats", async (req: any) => {
    const userId = req.userId;
    const { days = 7 } = req.query as any;

    const since = new Date(Date.now() - days * 86400000);

    const sessions = await prisma.studySession.findMany({
      where: {
        userId,
        createdAt: { gte: since },
      },
    });

    const totalMinutes = sessions.reduce((sum, s) => sum + s.minutes, 0);
    const totalHours = Math.round(totalMinutes / 60);

    const subjectBreakdown: Record<string, number> = {};
    sessions.forEach((s) => {
      subjectBreakdown[s.subject] = (subjectBreakdown[s.subject] || 0) + s.minutes;
    });

    return {
      days,
      totalMinutes,
      totalHours,
      sessionsCount: sessions.length,
      avgSessionMinutes: sessions.length > 0 ? Math.round(totalMinutes / sessions.length) : 0,
      subjectBreakdown,
    };
  });
}

