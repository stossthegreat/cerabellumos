import { FastifyInstance } from "fastify";
import { getWelcomeMessage, speakText } from "../controllers/companion.controller";
import { authMiddleware } from "../middleware/auth.middleware";

/**
 * Companion Routes - Voice messages and companion interactions
 */
export async function companionRoutes(fastify: FastifyInstance) {
  // GET /api/companion/welcome - Get personalized welcome message with voice
  fastify.get("/api/companion/welcome", getWelcomeMessage);

  // POST /api/companion/speak - Generate TTS for any text (testing/custom messages)
  fastify.post("/api/companion/speak", speakText);

  console.log("✅ Companion routes registered");
}

