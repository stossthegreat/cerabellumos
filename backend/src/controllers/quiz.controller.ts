// backend/src/controllers/quiz.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";

export async function quizController(fastify: FastifyInstance) {
  /**
   * POST /quiz/generate - Generate quiz from topic
   */
  fastify.post("/quiz/generate", async (req: any) => {
    const userId = req.userId;
    const { topic, subject, count = 5, difficulty = "medium" } = req.body;

    if (!topic || !subject) {
      return { error: "topic and subject required" };
    }

    const quiz = await aiService.generateQuiz(userId, {
      topic,
      subject,
      count,
      difficulty,
    });

    // Save quiz
    const saved = await prisma.quiz.create({
      data: {
        userId,
        subject,
        topic,
        questions: quiz.questions as any,
        difficulty,
      },
    });

    return {
      ok: true,
      quizId: saved.id,
      questions: quiz.questions,
    };
  });

  /**
   * POST /quiz/from-video/:videoId - Generate quiz from video summary
   */
  fastify.post("/quiz/from-video/:videoId", async (req: any) => {
    const userId = req.userId;
    const { videoId } = req.params;
    const { conceptIds, count = 5 } = req.body;

    const video = await prisma.videoSummary.findUnique({
      where: { id: videoId, userId },
    });

    if (!video) {
      return { error: "Video not found" };
    }

    const quiz = await aiService.generateQuizFromVideo(userId, {
      videoId,
      title: video.title,
      summary: video.summary,
      keyPoints: video.keyPoints as string[],
      conceptIds,
      count,
    });

    const saved = await prisma.quiz.create({
      data: {
        userId,
        subject: video.subject || "General",
        topic: video.topic || video.title,
        questions: quiz.questions as any,
        sourceType: "video",
        sourceId: videoId,
      },
    });

    return {
      ok: true,
      quizId: saved.id,
      questions: quiz.questions,
    };
  });

  /**
   * POST /quiz/from-scan/:scanId - Generate quiz from scanned problem
   */
  fastify.post("/quiz/from-scan/:scanId", async (req: any) => {
    const userId = req.userId;
    const { scanId } = req.params;
    const { count = 3 } = req.body;

    const scan = await prisma.scannedProblem.findUnique({
      where: { id: scanId, userId },
    });

    if (!scan) {
      return { error: "Scan not found" };
    }

    const quiz = await aiService.generateQuizFromScan(userId, {
      scanId,
      topic: scan.topic,
      subject: scan.subject,
      solution: scan.solution,
      explanation: scan.explanation,
      count,
    });

    const saved = await prisma.quiz.create({
      data: {
        userId,
        subject: scan.subject,
        topic: scan.topic,
        questions: quiz.questions as any,
        sourceType: "scan",
        sourceId: scanId,
      },
    });

    return {
      ok: true,
      quizId: saved.id,
      questions: quiz.questions,
    };
  });

  /**
   * POST /quiz/:id/submit - Submit quiz answers
   */
  fastify.post("/quiz/:id/submit", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { answers, timeSpent } = req.body;

    const quiz = await prisma.quiz.findUnique({
      where: { id, userId },
    });

    if (!quiz) {
      return { error: "Quiz not found" };
    }

    const questions = quiz.questions as any[];
    let correct = 0;
    questions.forEach((q, i) => {
      if (answers[i] === q.correct) correct++;
    });

    const score = Math.round((correct / questions.length) * 100);

    // Update quiz with results
    await prisma.quiz.update({
      where: { id },
      data: {
        score,
        completed: true,
        timeSpent,
      },
    });

    // Update topic mastery if applicable
    if (quiz.topic) {
      await prisma.topicMastery.upsert({
        where: {
          userId_subject_topic: {
            userId,
            subject: quiz.subject,
            topic: quiz.topic,
          },
        },
        create: {
          userId,
          subject: quiz.subject,
          topic: quiz.topic,
          score,
          sessionsCount: 1,
        },
        update: {
          score: Math.round((score * 0.3) + (await prisma.topicMastery.findUnique({
            where: {
              userId_subject_topic: {
                userId,
                subject: quiz.subject,
                topic: quiz.topic,
              },
            },
          }).then(m => m?.score || 0) * 0.7)),
          sessionsCount: { increment: 1 },
        },
      });
    }

    return {
      ok: true,
      score,
      correct,
      total: questions.length,
      passed: score >= 70,
    };
  });

  /**
   * GET /quiz/history - Get quiz history
   */
  fastify.get("/quiz/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 20 } = req.query as any;

    const quizzes = await prisma.quiz.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: limit,
    });

    return { quizzes };
  });
}

