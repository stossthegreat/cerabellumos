import Fastify from "fastify";
import cors from "@fastify/cors";
import swagger from "@fastify/swagger";
import swaggerUI from "@fastify/swagger-ui";
import dotenv from "dotenv";
import { prisma } from "./utils/db";
import { getRedis } from "./utils/redis";
import { initializeFirebaseAdmin } from "./utils/firebase-admin";
import { authMiddleware, optionalAuthMiddleware } from "./middleware/auth.middleware";

import { nudgesController } from "./controllers/nudges.controller";
import coachController from "./modules/coach/coach.controller";
import { systemController } from "./controllers/system.controller";
import { chatController } from "./controllers/chat.controller";
import { userController } from "./controllers/user.controller";
import { testController } from "./controllers/test.controller";
import { insightsController } from "./controllers/insights.controller";

// Study OS Controllers
import { intelController } from "./controllers/intel.controller";
import { studySessionsController } from "./controllers/study-sessions.controller";
import { examsController } from "./controllers/exams.controller";
import { masteryController } from "./controllers/mastery.controller";
import { scannerController } from "./controllers/scanner.controller";
import { videoController } from "./controllers/video.controller";
import { projectsController } from "./controllers/projects.controller";
import { studyTargetsController } from "./controllers/study-targets.controller";
import { statsController } from "./controllers/stats.controller";
import { identityController } from "./controllers/identity.controller";
import { quizController } from "./controllers/quiz.controller";
import { flashcardsController } from "./controllers/flashcards.controller";

// Legacy controllers (keeping for now, can remove later)
// import { whatIfController } from "./controllers/whatif.controller";
// import { futureYouChatController } from "./controllers/future-you-chat.controller";
// import { whatIfChatController } from "./controllers/what-if-chat.controller";
// import { futureYouChatControllerV2 } from "./controllers/future-you-v2.controller";
// import { reflectionsController } from "./controllers/reflections.controller";
// import { futureYouRouter } from "./modules/futureyou/router";
// import { lifeTaskRouter } from "./modules/lifetask/router";

dotenv.config();

// Initialize Firebase Admin on startup
try {
  initializeFirebaseAdmin();
} catch (error) {
  console.error('❌ Failed to initialize Firebase Admin:', error);
  console.warn('⚠️  Continuing without Firebase - auth will not work properly');
}

function validateEnv() {
  console.log("✅ Core env vars check: (lenient for Railway)");
}

const buildServer = () => {
  const fastify = Fastify({ 
    logger: true,
    bodyLimit: 10485760, // 10MB
    connectionTimeout: 0, // Disable connection timeout
    keepAliveTimeout: 1200000, // 🔥 20 MINUTES - NUCLEAR timeout!
    requestTimeout: 1200000, // 🔥 20 MINUTES - let AI generate FULL cards!
  });

  fastify.register(cors, {
    origin: true,
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "x-user-id", "idempotency-key"],
    credentials: true,
  });

  fastify.register(swagger, {
    openapi: {
      openapi: "3.0.0",
      info: { title: "Cerebellum Study OS API", version: "1.0.0" },
      servers: [{ url: process.env.BACKEND_PUBLIC_URL || "http://localhost:8080" }],
    },
  });
  fastify.register(swaggerUI, { routePrefix: "/docs", uiConfig: { docExpansion: "full" } });

  // Public routes (no auth required)
  fastify.get("/", async () => ({
    message: "Cerebellum Study OS Brain running",
    version: "1.0.0",
    docs: "/docs",
    health: "/health",
    status: "ok",
  }));
  
  fastify.get("/health", async () => ({
    ok: true,
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  }));
  
  // Debug endpoint to check Firebase initialization
  fastify.get("/debug/firebase", async () => {
    const { getFirebaseAdmin } = await import("./utils/firebase-admin");
    const firebaseApp = getFirebaseAdmin();
    return {
      firebase_initialized: firebaseApp !== null,
      has_service_account_env: !!process.env.FIREBASE_SERVICE_ACCOUNT,
      env_length: process.env.FIREBASE_SERVICE_ACCOUNT?.length || 0,
    };
  });

  // DEBUG: Check what name is stored for a user (NO AUTH - REMOVE IN PRODUCTION)
  fastify.get("/debug/user-name/:userId", async (req: any) => {
    try {
      const { userId } = req.params;
      const { memoryService } = await import("./services/memory.service");
      const { prisma } = await import("./utils/db");
      
      const [identity, factsRow, user] = await Promise.all([
        memoryService.getIdentityFacts(userId),
        prisma.userFacts.findUnique({ where: { userId } }),
        prisma.user.findUnique({ where: { id: userId } }),
      ]);
      
      const facts = (factsRow?.json as any) || {};
      
      return {
        userId: userId.substring(0, 8) + "...",
        email: user?.email,
        resolvedName: identity.name,
        rawData: {
          "facts.identity": facts.identity,
          "facts.name": facts.name,
          "identity.name": identity.name,
        }
      };
    } catch (err: any) {
      return { error: err.message };
    }
  });

  // Protected routes (Firebase auth required)
  // Apply auth middleware to all controllers
  fastify.register(async (protectedRoutes) => {
    // Add auth middleware hook for all routes in this scope
    protectedRoutes.addHook('preHandler', authMiddleware);
    
    // CORE controllers (keep)
    protectedRoutes.register(chatController);       // General chat
    protectedRoutes.register(nudgesController);     // Nudges (adapted for study)
    protectedRoutes.register(coachController);      // Coach messages
    protectedRoutes.register(systemController);     // System endpoints
    protectedRoutes.register(userController);       // User management
    protectedRoutes.register(insightsController);   // Pattern insights (KEEP!)
    
    // STUDY OS controllers (NEW)
    protectedRoutes.register(intelController);          // Daily Intel generation
    protectedRoutes.register(studySessionsController);  // Log & track sessions
    protectedRoutes.register(examsController);          // Exam management
    protectedRoutes.register(masteryController);        // Topic mastery tracking
    protectedRoutes.register(scannerController);        // OCR + AI solve
    protectedRoutes.register(videoController);          // Video summaries
    protectedRoutes.register(projectsController);       // Neural tab chat projects
    protectedRoutes.register(studyTargetsController);   // Study targets from Flutter
    protectedRoutes.register(statsController);          // User stats & analytics
    protectedRoutes.register(identityController);       // Identity Engine
    protectedRoutes.register(quizController);           // Quiz generation
    protectedRoutes.register(flashcardsController);     // Flashcard generation & spaced repetition
  });
  
  // Test routes (optional - can be public or protected based on needs)
  fastify.register(testController); // For manual testing

  return fastify;
};

const start = async () => {
  try {
    console.log("🚀 Starting Cerebellum Study OS Brain...");
    validateEnv();
    const server = buildServer();

    const port = Number(process.env.PORT || 8080);
    const host = process.env.HOST || "0.0.0.0";
    await server.listen({ port, host });

    console.log("✅ Cerebellum OS Brain running");
    console.log("📖 Docs: /docs | 🩺 Health: /health");
    console.log("⚠️ Note: Schedulers run in separate worker.ts process");
    console.log("🧠 Study Intelligence Active");
  } catch (err) {
    console.error("❌ Startup failed:", err);
    process.exit(1);
  }
};

process.on("SIGINT", async () => {
  console.log("⏹️ Graceful shutdown…");
  await prisma.$disconnect();
  await getRedis().quit();
  process.exit(0);
});

start();
