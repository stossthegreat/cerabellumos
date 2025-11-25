import { FastifyInstance } from "fastify";
import { getWelcomeMessage, speakText } from "../controllers/companion.controller";
import { authMiddleware } from "../middleware/auth.middleware";

/**
 * Companion Routes - Voice messages and companion interactions
 */
export async function companionRoutes(fastify: FastifyInstance) {
  // Apply auth middleware to all routes
  fastify.addHook("preHandler", authMiddleware);

  // GET /companion/welcome - Get personalized welcome message with voice
  fastify.get("/welcome", getWelcomeMessage);

  // POST /companion/speak - Generate TTS for any text (testing/custom messages)
  fastify.post("/speak", speakText);

  console.log("✅ Companion routes registered");
}

