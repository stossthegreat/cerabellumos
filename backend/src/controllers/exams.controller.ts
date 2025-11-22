// backend/src/controllers/exams.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { studyIntelligence } from "../services/study-intelligence.service";
import { schedulerQueue } from "../jobs/scheduler";

export async function examsController(fastify: FastifyInstance) {
  /**
   * POST /exams - Create new exam
   */
  fastify.post("/exams", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, date, weight, targetGrade, icon } = req.body;

    if (!subject || !date) {
      return { error: "subject and date required" };
    }

    const exam = await prisma.exam.create({
      data: {
        userId,
        subject,
        topic,
        date: new Date(date),
        weight: weight || 100,
        targetGrade,
        icon: icon || "📚",
      },
    });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "exam_created",
        payload: { examId: exam.id, subject, date },
      },
    });

    // Trigger threat recalculation
    await studyIntelligence.recalculateExamThreats(userId);

    // Schedule countdown alerts
    await scheduleExamAlerts(exam.id, userId, new Date(date));

    return { ok: true, exam };
  });

  /**
   * GET /exams - Get all exams with computed threat data
   */
  fastify.get("/exams", async (req: any) => {
    const userId = req.userId;

    const exams = await prisma.exam.findMany({
      where: { userId },
      orderBy: { date: "asc" },
    });

    // Enrich with latest threat calculations
    const consciousness = await studyIntelligence.buildStudyConsciousness(userId);
    const threatsMap = new Map(consciousness.exams.map((e) => [e.examId, e]));

    const enrichedExams = exams.map((exam) => {
      const threat = threatsMap.get(exam.id);
      return {
        ...exam,
        daysRemaining: threat?.daysRemaining || 0,
        threatLevel: threat?.threatLevel || "MEDIUM",
        progress: threat?.currentProgress || 0,
        prediction: threat?.prediction || "N/A",
        gapAnalysis: threat?.gapAnalysis || [],
      };
    });

    return { exams: enrichedExams };
  });

  /**
   * PUT /exams/:id - Update exam
   */
  fastify.put("/exams/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { subject, topic, date, weight, targetGrade, icon } = req.body;

    const exam = await prisma.exam.update({
      where: { id, userId },
      data: {
        ...(subject && { subject }),
        ...(topic !== undefined && { topic }),
        ...(date && { date: new Date(date) }),
        ...(weight !== undefined && { weight }),
        ...(targetGrade !== undefined && { targetGrade }),
        ...(icon && { icon }),
      },
    });

    // Recalculate threats
    await studyIntelligence.recalculateExamThreats(userId);

    return { ok: true, exam };
  });

  /**
   * DELETE /exams/:id - Delete exam
   */
  fastify.delete("/exams/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.exam.delete({
      where: { id, userId },
    });

    return { ok: true };
  });
}

// Helper function for scheduling exam alerts
async function scheduleExamAlerts(examId: string, userId: string, examDate: Date) {
  const now = new Date();
  const daysUntil = Math.ceil((examDate.getTime() - now.getTime()) / 86400000);

  // Schedule alerts at 14d, 7d, 3d, 1d thresholds
  const thresholds = [14, 7, 3, 1];

  for (const threshold of thresholds) {
    if (daysUntil > threshold) {
      const alertDate = new Date(examDate.getTime() - threshold * 86400000);

      await schedulerQueue.add(
        "exam-alert",
        { userId, examId, threshold },
        {
          delay: alertDate.getTime() - now.getTime(),
          jobId: `exam-alert:${examId}:${threshold}d`,
          removeOnComplete: true,
        }
      );
    }
  }
}

