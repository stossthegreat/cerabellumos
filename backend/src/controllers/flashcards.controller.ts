// backend/src/controllers/flashcards.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";

export async function flashcardsController(fastify: FastifyInstance) {
  /**
   * POST /flashcards/generate - Generate flashcards from topic
   */
  fastify.post("/flashcards/generate", async (req: any) => {
    const userId = req.userId;
    const { topic, subject, count = 10, difficulty = "medium" } = req.body;

    if (!topic || !subject) {
      return { error: "topic and subject required" };
    }

    const result = await aiService.generateFlashcards(userId, {
      topic,
      subject,
      count,
      difficulty,
    });

    // Save flashcards
    const cards = await Promise.all(
      result.cards.map((card) =>
        prisma.flashcard.create({
          data: {
            userId,
            front: card.front,
            back: card.back,
            subject,
            topic,
            difficulty,
          },
        })
      )
    );

    return {
      ok: true,
      cards: cards.map((c) => ({
        id: c.id,
        front: c.front,
        back: c.back,
        topic: c.topic,
        difficulty: c.difficulty,
      })),
    };
  });

  /**
   * GET /flashcards - Get flashcards
   */
  fastify.get("/flashcards", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, dueOnly } = req.query as any;

    const where: any = { userId };
    if (subject) where.subject = subject;
    if (topic) where.topic = topic;
    if (dueOnly === "true") {
      where.nextReview = { lte: new Date() };
    }

    const cards = await prisma.flashcard.findMany({
      where,
      orderBy: { nextReview: "asc" },
      take: 50,
    });

    const stats = await prisma.flashcard.groupBy({
      by: ["subject"],
      where: { userId },
      _count: true,
    });

    return {
      cards,
      stats,
      total: cards.length,
    };
  });

  /**
   * POST /flashcards/:id/review - Review flashcard (spaced repetition)
   */
  fastify.post("/flashcards/:id/review", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { quality } = req.body; // 1-5 rating

    if (quality < 1 || quality > 5) {
      return { error: "quality must be between 1 and 5" };
    }

    const card = await prisma.flashcard.findUnique({
      where: { id, userId },
    });

    if (!card) {
      return { error: "Card not found" };
    }

    // SM-2 algorithm (simplified spaced repetition)
    const easiness = Math.max(1.3, card.easiness + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)));
    const interval = calculateNextInterval(card.interval, quality, easiness);
    const nextReview = new Date(Date.now() + interval * 24 * 60 * 60 * 1000);

    await prisma.flashcard.update({
      where: { id },
      data: {
        easiness,
        interval,
        nextReview,
        reviewCount: { increment: 1 },
        lastReviewed: new Date(),
      },
    });

    return {
      ok: true,
      nextReview,
      interval,
    };
  });

  /**
   * GET /flashcards/due-today - Get cards due for review
   */
  fastify.get("/flashcards/due-today", async (req: any) => {
    const userId = req.userId;

    const dueCards = await prisma.flashcard.findMany({
      where: {
        userId,
        nextReview: { lte: new Date() },
      },
      orderBy: { nextReview: "asc" },
    });

    return {
      cards: dueCards,
      count: dueCards.length,
    };
  });

  /**
   * DELETE /flashcards/:id - Delete flashcard
   */
  fastify.delete("/flashcards/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.flashcard.delete({
      where: { id, userId },
    });

    return { ok: true };
  });
}

// Spaced repetition interval calculation
function calculateNextInterval(currentInterval: number, quality: number, easiness: number): number {
  if (quality < 3) {
    // Failed - reset to 1 day
    return 1;
  }

  if (currentInterval === 0) {
    // First review
    if (quality === 3) return 1;
    if (quality === 4) return 3;
    return 6;
  }

  // Subsequent reviews
  return Math.round(currentInterval * easiness);
}

