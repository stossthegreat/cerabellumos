// backend/src/controllers/scanner.controller.ts
import { FastifyInstance } from "fastify";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";
import { ocrService } from "../services/ocr.service";

export async function scannerController(fastify: FastifyInstance) {
  /**
   * POST /scan/ocr - Extract text from image
   */
  fastify.post("/scan/ocr", async (req: any) => {
    const userId = req.userId;
    const { imageBase64 } = req.body;

    if (!imageBase64) {
      return { error: "imageBase64 required" };
    }

    try {
      const result = await ocrService.extractText(imageBase64);
      const analysis = await ocrService.analyzeImageContent(imageBase64);

      return {
        ok: true,
        text: result.text,
        confidence: result.confidence,
        method: result.method,
        contentType: analysis.type,
        detectedElements: analysis.detectedElements,
      };
    } catch (err: any) {
      return { error: err.message };
    }
  });

  /**
   * POST /scan/solve - Solve scanned problem
   */
  fastify.post("/scan/solve", async (req: any) => {
    const userId = req.userId;
    const { ocrText, subject, imageUrl, imageBase64 } = req.body;

    let text = ocrText;

    // If imageBase64 provided, perform OCR first
    if (!text && imageBase64) {
      try {
        const ocrResult = await ocrService.extractText(imageBase64);
        text = ocrResult.text;
      } catch (err) {
        return { error: "OCR failed. Please provide text manually." };
      }
    }

    if (!text) {
      return { error: "ocrText or imageBase64 required" };
    }

    // AI solves the problem
    const solution = await aiService.solveProblem(userId, ocrText, subject);

    // Save to database
    const saved = await prisma.scannedProblem.create({
      data: {
        userId,
        subject: subject || solution.topic.split(" - ")[0] || "General",
        topic: solution.topic,
        imageUrl,
        ocrText,
        solution: solution.solution,
        explanation: solution.explanation,
      },
    });

    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "scan_solve",
        payload: { 
          scannedId: saved.id, 
          subject: saved.subject, 
          topic: saved.topic 
        },
      },
    });

    return {
      ok: true,
      solution: solution.solution,
      explanation: solution.explanation,
      topic: solution.topic,
      steps: solution.steps,
      savedId: saved.id,
    };
  });

  /**
   * GET /scan/history - Get scan history
   */
  fastify.get("/scan/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 20, saved } = req.query as any;

    const where: any = { userId };
    if (saved !== undefined) where.saved = saved === "true";

    const scans = await prisma.scannedProblem.findMany({
      where,
      orderBy: { createdAt: "desc" },
      take: limit,
    });

    return { scans };
  });

  /**
   * POST /scan/:id/save - Toggle save status
   */
  fastify.post("/scan/:id/save", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    const scan = await prisma.scannedProblem.findUnique({
      where: { id, userId },
    });

    if (!scan) {
      return { error: "Scan not found" };
    }

    const updated = await prisma.scannedProblem.update({
      where: { id },
      data: { saved: !scan.saved },
    });

    return { ok: true, scan: updated };
  });

  /**
   * DELETE /scan/:id - Delete scanned problem
   */
  fastify.delete("/scan/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;

    await prisma.scannedProblem.delete({
      where: { id, userId },
    });

    return { ok: true };
  });
}

