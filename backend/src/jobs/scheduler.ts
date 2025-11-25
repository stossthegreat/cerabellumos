// src/jobs/scheduler.ts
// 🧠 OS brain-only scheduler: briefs, debriefs, nudges, and weekly insights

import { Queue, Worker, JobsOptions } from "bullmq";
import { redis } from "../utils/redis";
import { prisma } from "../utils/db";
import { aiService } from "../services/ai.service";
import { coachMessageService } from "../services/coach-message.service";
import { notificationsService } from "../services/notifications.service";
import { voiceService } from "../services/voice.service";
// Removed nudgesService - using AI-generated study nudges instead
import { studyIntelligence } from "../services/study-intelligence.service";
import { aiStudyPrompts } from "../services/ai-study-prompts.service";
import { coachingService } from "../services/coaching.service";

const QUEUE = "scheduler";
export const schedulerQueue = new Queue(QUEUE, { connection: redis });

const PRO_FEATURES_ENABLED =
  (process.env.PRO_FEATURES_ENABLED || "true").toLowerCase() === "true";
const FREE_NOTIFICATIONS_ENABLED =
  (process.env.FREE_NOTIFICATIONS_ENABLED || "false").toLowerCase() === "true";

// Re-usable hourly repeat options (for ensure-* + auto-nudges-hourly)
function repeatHourly(): JobsOptions {
  return {
    repeat: { every: 60 * 60_000 },
    removeOnComplete: true,
    removeOnFail: true,
  };
}

// 🔌 Called from app bootstrap
export async function bootstrapSchedulers() {
  console.log("⏰ Cerebellum OS Schedulers Active");

  // Daily Intel (7am) - REPLACES daily-briefs
  await schedulerQueue.add("ensure-daily-intel", {}, {
    repeat: { every: 6 * 60 * 60_000 },
    removeOnComplete: true,
    removeOnFail: true,
  });

  // Study Nudges (10am, 2pm, 6pm)
  await schedulerQueue.add("ensure-study-nudges", {}, {
    repeat: { every: 6 * 60 * 60_000 },
    removeOnComplete: true,
    removeOnFail: true,
  });

  // Exam threshold alerts (check hourly)
  await schedulerQueue.add("exam-thresholds", {}, {
    repeat: { every: 60 * 60_000 },
    removeOnComplete: true,
    removeOnFail: true,
  });

  // Weak topic push (every 48 hours)
  await schedulerQueue.add("weak-topic-push", {}, {
    repeat: { every: 48 * 60 * 60_000 },
    removeOnComplete: true,
    removeOnFail: true,
  });

  // Weekly consolidation (Sundays at midnight)
  await schedulerQueue.add("weekly-consolidation", {}, {
    repeat: { pattern: "0 0 * * 0" }, // Sunday 00:00
    removeOnComplete: true,
    removeOnFail: true,
  });

  // Smart coaching messages (hourly)
  await schedulerQueue.add("coaching-messages", {}, {
    repeat: { every: 60 * 60_000 }, // Every hour
    removeOnComplete: true,
    removeOnFail: true,
  });

  console.log("✅ Study OS schedulers bootstrapped");
}

// ─────────────────────────────────────────────
// JOB DEFINITIONS
// ─────────────────────────────────────────────

// ============================================================
// STUDY OS JOB DEFINITIONS
// ============================================================

async function ensureDailyIntelJobs() {
  const users = await prisma.user.findMany({
    where: { intelEnabled: true },
    select: { id: true, tz: true },
  });
  
  for (const u of users) {
    const tz = u.tz || "Europe/London";
    await schedulerQueue.add(
      "daily-intel",
      { userId: u.id },
      {
        repeat: { pattern: "0 7 * * *", tz }, // 7am daily
        jobId: `daily-intel:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );
  }
  console.log(`✅ Ensured daily Intel for ${users.length} users`);
  return { ok: true, users: users.length };
}

async function ensureDailyBriefJobs() {
  // Keep for backward compatibility or remove later
  const users = await prisma.user.findMany({ select: { id: true, tz: true } });
  for (const u of users) {
    const tz = u.tz || "Europe/London";
    await schedulerQueue.add(
      "daily-brief",
      { userId: u.id },
      {
        repeat: { pattern: "0 7 * * *", tz },
        jobId: `daily-brief:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );
  }
  return { ok: true, users: users.length };
}

async function ensureEveningDebriefJobs() {
  const users = await prisma.user.findMany({ select: { id: true, tz: true } });
  for (const u of users) {
    const tz = u.tz || "Europe/London";
    await schedulerQueue.add(
      "evening-debrief",
      { userId: u.id },
      {
        repeat: { pattern: "0 21 * * *", tz },
        jobId: `evening-debrief:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );
  }
  return { ok: true, users: users.length };
}

async function ensureStudyNudgeJobs() {
  console.log(`\n🔧 ensureStudyNudgeJobs STARTING at ${new Date().toISOString()}`);
  
  const users = await prisma.user.findMany({
    where: { nudgesEnabled: true },
    select: { id: true, tz: true },
  });
  
  console.log(`🔧 Found ${users.length} users with nudges enabled`);

  for (const u of users) {
    const tz = u.tz || "Europe/London";

    // Remove existing to prevent duplicates
    const jobIds = [
      `study-nudge-morning:${u.id}`,
      `study-nudge-afternoon:${u.id}`,
      `study-nudge-evening:${u.id}`,
    ];
    
    for (const jobId of jobIds) {
      try {
        const job = await schedulerQueue.getJob(jobId);
        if (job) await job.remove();
      } catch (err) {
        // Job doesn't exist
      }
    }

    // Morning study nudge (10am)
    await schedulerQueue.add(
      "study-nudge",
      { userId: u.id, trigger: "morning_momentum" },
      {
        repeat: { pattern: "0 10 * * *", tz },
        jobId: `study-nudge-morning:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );

    // Afternoon drift check (2pm)
    await schedulerQueue.add(
      "study-nudge",
      { userId: u.id, trigger: "afternoon_drift" },
      {
        repeat: { pattern: "0 14 * * *", tz },
        jobId: `study-nudge-afternoon:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );

    // Evening progress check (6pm)
    await schedulerQueue.add(
      "study-nudge",
      { userId: u.id, trigger: "evening_closeout" },
      {
        repeat: { pattern: "0 18 * * *", tz },
        jobId: `study-nudge-evening:${u.id}`,
        removeOnComplete: true,
        removeOnFail: true,
      }
    );
  }
  
  console.log(`✅ Study nudges scheduled for ${users.length} users\n`);
  return { ok: true, users: users.length };
}

async function ensureNudgeJobs() {
  // Redirect to study nudges
  return ensureStudyNudgeJobs();
}

async function runDailyIntel(userId: string) {
  console.log(`\n📊 ================================`);
  console.log(`📊 Generating Daily Intel`);
  console.log(`📊 User: ${userId}`);
  console.log(`📊 Time: ${new Date().toISOString()}`);
  console.log(`📊 ================================\n`);

  try {
    const intel = await aiService.generateDailyIntel(userId);

    // Store as CoachMessage (kind = intel)
    await coachMessageService.createMessage(userId, "intel" as any, intel.fullText, {
      threatAssessment: intel.threatAssessment,
      weaknesses: intel.weaknesses,
      predictions: intel.predictions,
      missions: intel.todaysMissions,
      insights: intel.insights,
    });

    // Event for memory
    await prisma.event.create({
      data: {
        userId,
        type: "daily_intel",
        payload: intel,
      },
    });

    // Push notification
    await notificationsService.send(
      userId,
      "📊 Daily Intel",
      intel.threatAssessment.slice(0, 180)
    );

    console.log(`✅ Daily Intel complete for ${userId}\n`);
    return { ok: true };
  } catch (err) {
    console.error(`❌ Daily Intel failed for ${userId}:`, err);
    return { ok: false, error: String(err) };
  }
}

async function runDailyBrief(userId: string) {
  // Redirect to Intel for now, or keep old logic for backward compat
  return runDailyIntel(userId);
}

async function runEveningDebrief(userId: string) {
  const text =
    (await aiService.generateEveningDebrief(userId).catch(() => null)) ||
    "Evening debrief.";

  // TTS disabled for now (legacy code from Future You OS)
  let audioUrl: string | null = null;

  // Store as CoachMessage (kind = mirror)
  await coachMessageService.createMessage(userId, "mirror", text, { audioUrl });

  // Backwards compat event
  await prisma.event.create({
    data: { userId, type: "evening_debrief", payload: { text, audioUrl } },
  });

  await notificationsService.send(userId, "Evening Debrief", text.slice(0, 180));
  return { ok: true };
}

async function runStudyNudge(userId: string, trigger: string) {
  const timestamp = new Date().toISOString();
  console.log(`\n🔔 ================================`);
  console.log(`🔔 STUDY NUDGE`);
  console.log(`🔔 Time: ${timestamp}`);
  console.log(`🔔 User: ${userId}`);
  console.log(`🔔 Trigger: ${trigger}`);
  console.log(`🔔 ================================\n`);
  
  try {
    const text = await aiService.generateStudyNudge(userId, trigger);
    console.log(`📝 Generated nudge: "${text.substring(0, 80)}..."`);

    // Store as CoachMessage
    await coachMessageService.createMessage(userId, "nudge", text, { trigger });

    // Event for memory
    await prisma.event.create({
      data: { userId, type: "study_nudge", payload: { text, trigger } },
    });

    // Push notification
    await notificationsService.send(userId, "🔥 Study Push", text.slice(0, 180));

    console.log(`✅ Study nudge complete for ${userId}\n`);
    return { ok: true };
  } catch (err) {
    console.error(`❌ Study nudge failed:`, err);
    return { ok: false, error: String(err) };
  }
}

async function runNudge(userId: string, trigger: string) {
  // Redirect to study nudge
  return runStudyNudge(userId, trigger);
}

async function autoNudgesHourly() {
  // DEPRECATED - nudges now handled by scheduled jobs (10am, 2pm, 6pm)
  // using AI-generated study-aware nudges
  return { ok: true };
}

async function checkExamThresholds() {
  console.log(`\n🚨 Checking exam thresholds at ${new Date().toISOString()}`);

  const now = new Date();
  const twoWeeksOut = new Date(now.getTime() + 14 * 86400000);

  const exams = await prisma.exam.findMany({
    where: {
      date: {
        gte: now,
        lte: twoWeeksOut,
      },
    },
    include: { user: true },
  });

  console.log(`📋 Found ${exams.length} exams in next 14 days`);

  let alertsSent = 0;
  for (const exam of exams) {
    const daysRemaining = Math.ceil(
      (new Date(exam.date).getTime() - now.getTime()) / 86400000
    );

    // Fire alerts at exact thresholds
    if ([14, 7, 3, 1].includes(daysRemaining)) {
      console.log(`🚨 THRESHOLD ALERT: ${exam.subject} in ${daysRemaining} days`);

      // Get full exam threat data
      const consciousness = await studyIntelligence.buildStudyConsciousness(exam.userId);
      const threat = consciousness.exams.find((e) => e.examId === exam.id);

      if (threat) {
        const alertText = aiStudyPrompts.buildExamAlert(threat, daysRemaining);

        await coachMessageService.createMessage(exam.userId, "exam_alert" as any, alertText, {
          examId: exam.id,
          threshold: daysRemaining,
          subject: exam.subject,
        });

        await notificationsService.send(
          exam.userId,
          `🚨 ${exam.subject} in ${daysRemaining} days`,
          alertText.slice(0, 180)
        );

        alertsSent++;
      }
    }
  }

  console.log(`✅ Sent ${alertsSent} exam threshold alerts\n`);
  return { ok: true, checked: exams.length, alertsSent };
}

async function pushWeakTopics() {
  console.log(`\n⚡ Pushing weak topics at ${new Date().toISOString()}`);

  const users = await prisma.user.findMany({
    where: { studyReminders: true },
    select: { id: true },
  });

  let pushesSent = 0;
  for (const user of users) {
    try {
      const consciousness = await studyIntelligence.buildStudyConsciousness(user.id);

      // If weak topics + upcoming exams = send push
      if (consciousness.weakTopics.length > 0 && consciousness.exams.length > 0) {
        const criticalWeakness = consciousness.weakTopics[0];
        const relatedExam = consciousness.exams.find((e) =>
          e.subject.toLowerCase().includes(criticalWeakness.split(" - ")[0].toLowerCase())
        );

        if (relatedExam && relatedExam.daysRemaining < 30) {
          const nudgeText = `${criticalWeakness} is still weak (${consciousness.topicMastery[criticalWeakness] || 40}%). ${relatedExam.subject} exam in ${relatedExam.daysRemaining} days. Attack this today.`;

          await coachMessageService.createMessage(
            user.id,
            "mastery_alert" as any,
            nudgeText,
            {
              trigger: "weak_topic_push",
              topic: criticalWeakness,
              examId: relatedExam.examId,
            }
          );

          await notificationsService.send(
            user.id,
            "⚡ Weak Topic Alert",
            nudgeText.slice(0, 180)
          );

          pushesSent++;
        }
      }
    } catch (err) {
      console.error(`Failed weak topic push for ${user.id}:`, err);
    }
  }

  console.log(`✅ Sent ${pushesSent} weak topic alerts\n`);
  return { ok: true, sent: pushesSent };
}

async function analyzeStudySession(sessionId: string) {
  console.log(`\n🔍 Analyzing study session: ${sessionId}`);

  try {
    const session = await prisma.studySession.findUnique({
      where: { id: sessionId },
    });

    if (!session) {
      console.warn(`⚠️ Session ${sessionId} not found`);
      return { ok: false };
    }

    // Update mastery from session
    await studyIntelligence.updateMasteryFromSession(session);

    // Recalculate exam threats
    await studyIntelligence.recalculateExamThreats(session.userId);

    console.log(`✅ Session ${sessionId} analyzed\n`);
    return { ok: true };
  } catch (err) {
    console.error(`❌ Session analysis failed:`, err);
    return { ok: false, error: String(err) };
  }
}

async function runWeeklyConsolidation() {
  const users = await prisma.user.findMany({ select: { id: true } });
  console.log(`📅 Running weekly study consolidation for ${users.length} users...`);

  for (const u of users) {
    try {
      // Rebuild patterns from last week
      await studyIntelligence.extractStudyPatterns(u.id, []);
      
      // Could generate weekly report here
      // For now, just log
      console.log(`✅ Consolidated patterns for ${u.id}`);
    } catch (err) {
      console.error(`Failed weekly consolidation for ${u.id}:`, err);
    }
  }

  return { ok: true, processed: users.length };
}

async function generateCoachingMessages() {
  const users = await prisma.user.findMany({
    where: { coachingEnabled: true },
    select: { id: true },
  });

  console.log(`🎯 Generating smart coaching messages for ${users.length} users...`);

  let messagesGenerated = 0;
  for (const user of users) {
    try {
      const messages = await coachingService.generateSmartCoaching(user.id);
      await coachingService.storeCoachingMessages(user.id, messages);
      messagesGenerated += messages.length;
      console.log(`✅ Generated ${messages.length} coaching messages for ${user.id}`);
    } catch (err) {
      console.error(`Failed coaching generation for ${user.id}:`, err);
    }
  }

  console.log(`✅ Total coaching messages generated: ${messagesGenerated}\n`);
  return { ok: true, users: users.length, messages: messagesGenerated };
}

// ─────────────────────────────────────────────
// WORKER - ONLY START WHEN EXPLICITLY CALLED
// ─────────────────────────────────────────────

let workerInstance: Worker | null = null;

/**
 * 🚨 CRITICAL: Start the worker ONLY from worker.ts
 * This prevents duplicate workers when server.ts imports this file
 */
export function startWorker() {
  if (workerInstance) {
    console.log("⚠️ Worker already running, skipping duplicate instantiation");
    return workerInstance;
  }

  console.log("🏭 STARTING SCHEDULER WORKER...");
  
  workerInstance = new Worker(
    QUEUE,
    async (job) => {
      console.log(`\n🏭 WORKER processing job: ${job.name} [ID: ${job.id}] at ${new Date().toISOString()}`);
      if (job.name === "nudge") {
        console.log(`🏭 NUDGE JOB DATA:`, JSON.stringify(job.data));
      }
      
      switch (job.name) {
        // Study OS jobs
        case "ensure-daily-intel":
          return ensureDailyIntelJobs();
        case "ensure-study-nudges":
          return ensureStudyNudgeJobs();
        case "daily-intel":
          return runDailyIntel(job.data.userId);
        case "study-nudge":
          return runStudyNudge(job.data.userId, job.data.trigger);
        case "exam-thresholds":
          return checkExamThresholds();
        case "weak-topic-push":
          return pushWeakTopics();
        case "analyze-session":
          return analyzeStudySession(job.data.sessionId);
        case "weekly-consolidation":
          return runWeeklyConsolidation();
        case "coaching-messages":
          return generateCoachingMessages();
          
        // Legacy/backward compat
        case "ensure-daily-briefs":
          return ensureDailyBriefJobs();
        case "ensure-evening-debriefs":
          return ensureEveningDebriefJobs();
        case "ensure-nudges":
          return ensureNudgeJobs();
        case "daily-brief":
          return runDailyBrief(job.data.userId);
        case "evening-debrief":
          return runEveningDebrief(job.data.userId);
        case "nudge":
          return runNudge(job.data.userId, job.data.trigger);
          
        default:
          console.warn(`⚠️ Unknown job type: ${job.name}`);
          return;
      }
    },
    { 
      connection: redis,
      // CRITICAL: Ensure only ONE worker processes each job
      concurrency: 1,
    }
  );

  console.log("🧠 Scheduler Worker Started (OS Brain Only)");
  return workerInstance;
}
