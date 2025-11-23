// backend/src/routes/coaching.routes.ts
// 🎯 API endpoints for smart coaching system

import { FastifyInstance } from "fastify";
import { coachingService } from "../services/coaching.service";
import { authMiddleware } from "../middleware/auth.middleware";

export async function coachingRoutes(fastify: FastifyInstance) {
  // Get active coaching messages for current user
  fastify.get(
    "/api/coaching/messages",
    { preHandler: [authMiddleware] },
    async (request, reply) => {
      const userId = (request as any).userId;

      try {
        const messages = await coachingService.getActiveMessages(userId);
        return reply.send(messages);
      } catch (error) {
        console.error("Error fetching coaching messages:", error);
        return reply.status(500).send({ error: "Failed to fetch coaching messages" });
      }
    }
  );

  // Dismiss a coaching message
  fastify.post(
    "/api/coaching/messages/:id/dismiss",
    { preHandler: [authMiddleware] },
    async (request, reply) => {
      const { id } = request.params as { id: string };

      try {
        await coachingService.dismissMessage(id);
        return reply.send({ success: true });
      } catch (error) {
        console.error("Error dismissing coaching message:", error);
        return reply.status(500).send({ error: "Failed to dismiss message" });
      }
    }
  );

  // Mark coaching message as completed (user acted on it)
  fastify.post(
    "/api/coaching/messages/:id/complete",
    { preHandler: [authMiddleware] },
    async (request, reply) => {
      const { id } = request.params as { id: string };
      const { actionType } = request.body as { actionType: string };

      try {
        await coachingService.completeMessage(id, actionType);
        return reply.send({ success: true });
      } catch (error) {
        console.error("Error completing coaching message:", error);
        return reply.status(500).send({ error: "Failed to complete message" });
      }
    }
  );

  // Manually trigger coaching generation (for testing)
  fastify.post(
    "/api/coaching/generate",
    { preHandler: [authMiddleware] },
    async (request, reply) => {
      const userId = (request as any).userId;

      try {
        const messages = await coachingService.generateSmartCoaching(userId);
        await coachingService.storeCoachingMessages(userId, messages);
        return reply.send({ success: true, count: messages.length });
      } catch (error) {
        console.error("Error generating coaching messages:", error);
        return reply.status(500).send({ error: "Failed to generate coaching messages" });
      }
    }
  );
}

