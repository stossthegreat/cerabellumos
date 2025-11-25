import { FastifyRequest, FastifyReply } from "fastify";
import { prisma } from "../utils/db";
import { voiceService } from "../services/voice.service";

/**
 * Companion Controller - Voice messages and companion interactions
 */

interface WelcomeMessageParams {
  userId: string;
  hour: number;
}

/**
 * GET /companion/welcome
 * Generate personalized welcome message with voice
 */
export async function getWelcomeMessage(
  request: FastifyRequest<{
    Querystring: { hour?: string };
  }>,
  reply: FastifyReply
) {
  try {
    const userId = (request as any).userId;
    const hour = parseInt(request.query.hour || String(new Date().getHours()));

    console.log(`🎤 Generating welcome message for user: ${userId}, hour: ${hour}`);

    // Get user's recent data
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        studyTargets: {
          where: {
            status: { in: ["at_risk", "struggling"] },
          },
          take: 3,
        },
        sessions: {
          where: {
            createdAt: {
              gte: new Date(Date.now() - 24 * 60 * 60 * 1000), // Last 24 hours
            },
          },
          orderBy: { createdAt: "desc" },
          take: 1,
        },
      },
    });

    // Generate contextual welcome message
    const { text, emotion } = generateWelcomeText(user, hour);

    // Generate TTS audio
    let audioBase64 = null;
    if (voiceService.isConfigured()) {
      const audioBuffer = await voiceService.generateSpeech(text, emotion);
      if (audioBuffer) {
        audioBase64 = voiceService.bufferToBase64(audioBuffer);
      }
    }

    return reply.send({
      text,
      emotion,
      audioBase64,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    console.error("❌ Error generating welcome message:", error);
    return reply.status(500).send({
      error: "Failed to generate welcome message",
      message: error.message,
    });
  }
}

/**
 * POST /companion/speak
 * Generate TTS for any text (for testing or custom messages)
 */
export async function speakText(
  request: FastifyRequest<{
    Body: {
      text: string;
      emotion?: "calm" | "urgent" | "hype" | "encouraging";
    };
  }>,
  reply: FastifyReply
) {
  try {
    const { text, emotion = "calm" } = request.body;

    if (!text || text.trim().length === 0) {
      return reply.status(400).send({ error: "Text is required" });
    }

    if (!voiceService.isConfigured()) {
      return reply.status(503).send({
        error: "Voice service not configured",
        message: "ELEVENLABS_API_KEY and ELEVENLABS_VOICE_ID must be set",
      });
    }

    const audioBuffer = await voiceService.generateSpeech(text, emotion);
    if (!audioBuffer) {
      return reply.status(500).send({ error: "Failed to generate speech" });
    }

    const audioBase64 = voiceService.bufferToBase64(audioBuffer);

    return reply.send({
      text,
      emotion,
      audioBase64,
      timestamp: new Date().toISOString(),
    });
  } catch (error: any) {
    console.error("❌ Error in speakText:", error);
    return reply.status(500).send({
      error: "Failed to generate speech",
      message: error.message,
    });
  }
}

/**
 * Generate contextual welcome message based on user data
 */
function generateWelcomeText(
  user: any,
  hour: number
): { text: string; emotion: "calm" | "urgent" | "hype" | "encouraging" } {
  // Time-based greeting
  let greeting = "Hey there";
  if (hour >= 5 && hour < 12) greeting = "Morning champion";
  else if (hour >= 12 && hour < 17) greeting = "Afternoon";
  else if (hour >= 17 && hour < 22) greeting = "Evening";
  else greeting = "Still up? Let's make it count";

  // Get study context
  const todayMinutes = user?.sessions?.[0]?.durationMinutes || 0;
  const atRiskTopics = user?.studyTargets?.filter((t: any) => t.status === "at_risk") || [];
  const strugglingTopics = user?.studyTargets?.filter((t: any) => t.status === "struggling") || [];

  // FIRST TIME / NO DATA
  if (!user || (!todayMinutes && atRiskTopics.length === 0)) {
    return {
      text: `${greeting}. Ready to dominate today? I'll be tracking your patterns and helping you get that edge. Let's start strong.`,
      emotion: "encouraging",
    };
  }

  // STRONG START (already studied today)
  if (todayMinutes > 30) {
    return {
      text: `${greeting}. You've already put in ${todayMinutes} minutes today. That's real commitment. Let's keep that momentum rolling.`,
      emotion: "hype",
    };
  }

  // AT-RISK TOPICS DETECTED
  if (atRiskTopics.length > 0) {
    const topicNames = atRiskTopics.slice(0, 2).map((t: any) => t.name).join(" and ");
    return {
      text: `${greeting}. Real talk: ${topicNames} needs attention. You're at risk of falling behind. Let's fix that today before it becomes a problem.`,
      emotion: "urgent",
    };
  }

  // STRUGGLING TOPICS
  if (strugglingTopics.length > 0) {
    const topicName = strugglingTopics[0].name;
    return {
      text: `${greeting}. I see you're working on ${topicName}. It's challenging, but you're making progress. Let's break it down and master it step by step.`,
      emotion: "encouraging",
    };
  }

  // DEFAULT - FRESH START
  if (hour >= 5 && hour < 12) {
    return {
      text: `${greeting}. Your brain is sharpest right now. Perfect time to tackle the hard stuff. What are we conquering today?`,
      emotion: "calm",
    };
  } else if (hour >= 17 && hour < 22) {
    return {
      text: `${greeting}. Evening is your power window. Focus is high, distractions are low. This is when you build that edge over everyone else.`,
      emotion: "calm",
    };
  }

  // LATE NIGHT
  return {
    text: `${greeting}. Late night grind? I respect it. Make these hours count. Quality over quantity. Let's be strategic.`,
    emotion: "calm",
  };
}

