// backend/src/controllers/identity.controller.ts
import { FastifyInstance } from "fastify";
import { buildUserIntelState } from "../services/intel/buildUserIntelState";

export async function identityController(fastify: FastifyInstance) {
  /**
   * GET /user/identity - Get user's study identity from unified intel
   */
  fastify.get("/user/identity", async (req: any) => {
    const userId = req.userId;

    // Load unified intelligence state
    const intel = await buildUserIntelState(userId);

    return {
      archetype: intel.identity.archetype,
      archetypeIcon: intel.identity.archetypeIcon,
      confidence: intel.identity.confidence,
      direction: intel.identity.direction,
      directionTrend: intel.identity.directionTrend,
      drivers: intel.identity.drivers,
      riskTag: intel.identity.riskTag,
      currentState: intel.identity.currentState,
      targetState: intel.identity.targetState,
      evolutionProgress: intel.identity.evolutionProgress,
      lastChange: intel.identity.lastChange,
    };
  });

  /**
   * GET /user/full-intel - Get complete intelligence state
   */
  fastify.get("/user/full-intel", async (req: any) => {
    const userId = req.userId;
    const intel = await buildUserIntelState(userId);
    return intel;
  });
}

