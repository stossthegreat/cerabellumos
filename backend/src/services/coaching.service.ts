// backend/src/services/coaching.service.ts
// 🎯 Smart Coaching System - Proactive Intelligence + Action

import { prisma } from "../utils/db";
import { buildUserIntelState } from "./intel/buildUserIntelState";
import { UserIntelState } from "./intel/types";

export interface CoachingAction {
  type: string; // "flashcards", "quiz", "deep_dive", "scan", "video", "quick_review"
  label: string;
  payload: Record<string, any>;
}

export interface WeakArea {
  topic: string;
  mastery: number;
}

export interface CoachingPlan {
  description: string;
  totalTime: number; // minutes
  predictedGain?: number; // percentage
  breakdown?: string[];
  reasoning?: string;
  urgency?: string;
}

export interface CoachingMessageData {
  type: string; // "exam_prep", "drift_recovery", "momentum", "consistency"
  priority: string; // "high", "medium", "low"
  title: string;
  weakAreas?: WeakArea[];
  context?: Record<string, any>;
  plan: CoachingPlan;
  actions: CoachingAction[];
}

class CoachingService {
  /**
   * Generate smart coaching messages for a user
   * Analyzes intelligence state and creates actionable guidance
   */
  async generateSmartCoaching(userId: string): Promise<CoachingMessageData[]> {
    const intel = await buildUserIntelState(userId);
    const messages: CoachingMessageData[] = [];

    // 1. EXAM PREP MESSAGES (Highest priority)
    messages.push(...this.generateExamPrepMessages(intel));

    // 2. DRIFT RECOVERY MESSAGES
    messages.push(...this.generateDriftRecoveryMessages(intel));

    // 3. MOMENTUM OPPORTUNITY MESSAGES
    messages.push(...this.generateMomentumMessages(intel));

    // 4. CONSISTENCY BUILDER MESSAGES
    messages.push(...this.generateConsistencyMessages(intel));

    // Sort by priority
    return messages.sort((a, b) => {
      const priorityOrder = { high: 0, medium: 1, low: 2 };
      return priorityOrder[a.priority as keyof typeof priorityOrder] - priorityOrder[b.priority as keyof typeof priorityOrder];
    });
  }

  /**
   * Generate exam preparation coaching messages
   * Focuses on weak topics with upcoming exams
   */
  private generateExamPrepMessages(intel: UserIntelState): CoachingMessageData[] {
    const messages: CoachingMessageData[] = [];

    for (const exam of intel.exams) {
      // Only coach for exams within 14 days
      if (exam.daysRemaining > 14) continue;

      // Find weak topics for this exam subject
      const examWeakTopics = intel.mastery.weakTopics.filter((topic) => {
        const topicSubject = topic.split(" - ")[0].toLowerCase();
        return exam.subject.toLowerCase().includes(topicSubject) || topicSubject.includes(exam.subject.toLowerCase());
      });

      if (examWeakTopics.length === 0) continue;

      const weakAreas: WeakArea[] = examWeakTopics.map((topic) => {
        const match = topic.match(/\((\d+)%\)/);
        const mastery = match ? parseInt(match[1]) : 50;
        const topicName = topic.split(" (")[0].replace(/ - \d+%$/, "");
        return { topic: topicName, mastery };
      });

      const avgMastery = weakAreas.reduce((sum, a) => sum + a.mastery, 0) / weakAreas.length;
      const masteryGainNeeded = Math.max(0, 75 - avgMastery); // Target 75% mastery
      const dailyMinutes = Math.min(30, Math.ceil((masteryGainNeeded / 15) * 10)); // 10 min per 15% gain
      const totalMinutes = dailyMinutes * exam.daysRemaining;
      const predictedGain = Math.min(masteryGainNeeded, Math.ceil((totalMinutes / 10) * 15));

      messages.push({
        type: "exam_prep",
        priority: exam.threatLevel === "CRITICAL" || exam.daysRemaining <= 3 ? "high" : "medium",
        title: `${exam.subject} Exam in ${exam.daysRemaining} Day${exam.daysRemaining !== 1 ? "s" : ""}`,
        weakAreas,
        plan: {
          description: `${dailyMinutes} min/day focused practice (${exam.daysRemaining} days)`,
          totalTime: totalMinutes,
          predictedGain,
          breakdown: this.generateExamBreakdown(weakAreas, exam.daysRemaining),
        },
        actions: [
          {
            type: "flashcards",
            label: "Generate Flashcards",
            payload: {
              topics: weakAreas.map((a) => a.topic),
              count: 20,
              difficulty: avgMastery < 50 ? "easy" : "medium",
            },
          },
          {
            type: "quiz",
            label: "Start Quiz",
            payload: {
              topics: weakAreas.map((a) => a.topic),
              questions: 10,
              adaptive: true,
            },
          },
          {
            type: "deep_dive",
            label: "Deep Dive Lesson",
            payload: {
              topic: weakAreas[0].topic,
            },
          },
        ],
      });
    }

    return messages;
  }

  /**
   * Generate drift recovery coaching messages
   * Alerts when user hasn't studied a topic in a while
   */
  private generateDriftRecoveryMessages(intel: UserIntelState): CoachingMessageData[] {
    const messages: CoachingMessageData[] = [];

    // Analyze recent sessions for drift patterns
    const now = new Date();
    const topicLastStudied = new Map<string, { date: Date; duration: number }>();

    for (const session of intel.recentSessions) {
      const topic = session.subject || "General";
      const sessionDate = new Date(session.createdAt);
      
      if (!topicLastStudied.has(topic) || topicLastStudied.get(topic)!.date < sessionDate) {
        topicLastStudied.set(topic, {
          date: sessionDate,
          duration: session.minutes || 0,
        });
      }
    }

    // Check for drifts (topics not studied in 3+ days)
    for (const [topic, last] of topicLastStudied) {
      const daysSince = Math.floor((now.getTime() - last.date.getTime()) / (1000 * 60 * 60 * 24));
      
      if (daysSince >= 3) {
        // Check if this topic has an upcoming exam
        const relatedExam = intel.exams.find((e) =>
          e.subject.toLowerCase().includes(topic.toLowerCase()) ||
          topic.toLowerCase().includes(e.subject.toLowerCase())
        );

        if (relatedExam && relatedExam.daysRemaining <= 30) {
          const masteryDecay = Math.min(15, daysSince * 2); // 2% decay per day, max 15%

          messages.push({
            type: "drift_recovery",
            priority: daysSince >= 5 ? "high" : "medium",
            title: `${daysSince}-Day Drift on ${topic}`,
            context: {
              lastSessionDate: last.date.toLocaleDateString(),
              lastDuration: `${last.duration} min`,
              masteryDecay: `-${masteryDecay}%`,
              examDays: relatedExam.daysRemaining,
            },
            plan: {
              description: "15 min recovery session today to stop decay",
              totalTime: 15,
              urgency: "Recovery session - prevent further mastery loss",
            },
            actions: [
              {
                type: "quick_review",
                label: "Quick Review",
                payload: { topic, duration: 15 },
              },
              {
                type: "video",
                label: "Watch Explanation",
                payload: { topic },
              },
              {
                type: "flashcards",
                label: "Flashcard Review",
                payload: { topics: [topic], count: 10, difficulty: "easy" },
              },
            ],
          });
        }
      }
    }

    return messages;
  }

  /**
   * Generate momentum opportunity messages
   * Alerts during peak performance windows
   */
  private generateMomentumMessages(intel: UserIntelState): CoachingMessageData[] {
    const messages: CoachingMessageData[] = [];

    // Check if user is in peak performance window
    const now = new Date();
    const currentHour = now.getHours();
    
    // Parse peak window (e.g., "9-11 AM")
    const peakWindow = intel.studyPatterns.peakPerformanceWindow;
    if (!peakWindow) return messages;

    const match = peakWindow.match(/(\d+)-(\d+)/);
    if (!match) return messages;

    const [, startStr, endStr] = match;
    const start = parseInt(startStr);
    const end = parseInt(endStr);

    // If we're in the peak window
    if (currentHour >= start && currentHour < end) {
      const hardestTopic = intel.mastery.weakTopics[0];
      if (!hardestTopic) return messages;

      const topicName = hardestTopic.split(" (")[0];
      const match2 = hardestTopic.match(/\((\d+)%\)/);
      const mastery = match2 ? parseInt(match2[1]) : 50;

      messages.push({
        type: "momentum",
        priority: "high",
        title: "Peak Performance Window",
        context: {
          peakWindow,
          masteryBoost: "+12% avg during this time",
          currentTopic: topicName,
          currentMastery: `${mastery}%`,
        },
        plan: {
          description: `Attack hardest topic now: ${topicName}`,
          totalTime: 30,
          reasoning: "Cognitive performance peak detected - optimal time for difficult material",
        },
        actions: [
          {
            type: "deep_dive",
            label: "Start Deep Dive",
            payload: { topic: topicName },
          },
          {
            type: "scan",
            label: "Scan Problems",
            payload: { topic: topicName },
          },
          {
            type: "quiz",
            label: "Challenge Quiz",
            payload: { topics: [topicName], questions: 5, adaptive: true },
          },
        ],
      });
    }

    return messages;
  }

  /**
   * Generate consistency building messages
   * Helps build study habits
   */
  private generateConsistencyMessages(intel: UserIntelState): CoachingMessageData[] {
    const messages: CoachingMessageData[] = [];

    const consistencyScore = intel.studyPatterns.consistencyScore || 0;
    
    // Only coach if consistency is below 70%
    if (consistencyScore >= 70) return messages;

    const currentStreak = 0; // TODO: Calculate from identity or sessions
    const targetStreak = 7;

    messages.push({
      type: "consistency",
      priority: "low",
      title: "Build Study Consistency",
      context: {
        currentStreak,
        targetStreak,
        consistencyScore: `${consistencyScore}%`,
      },
      plan: {
        description: "5 min daily check-ins for 7 days",
        totalTime: 35,
        predictedGain: 25, // +25% consistency score
        reasoning: "Small daily wins build long-term habits",
      },
      actions: [
        {
          type: "micro_session",
          label: "Start 5-Min Session",
          payload: { duration: 5 },
        },
        {
          type: "flashcards",
          label: "Quick Flashcards",
          payload: { count: 5, difficulty: "easy" },
        },
      ],
    });

    return messages;
  }

  /**
   * Helper: Generate breakdown for exam prep plan
   */
  private generateExamBreakdown(weakAreas: WeakArea[], days: number): string[] {
    if (days <= 2) {
      return [`Days 1-${days}: Focus on all weak areas with mixed review`];
    }

    const breakdown: string[] = [];
    const daysPerTopic = Math.floor(days / weakAreas.length);
    const remainingDays = days % weakAreas.length;

    let currentDay = 1;
    for (let i = 0; i < weakAreas.length; i++) {
      const topicDays = daysPerTopic + (i < remainingDays ? 1 : 0);
      const endDay = currentDay + topicDays - 1;
      
      breakdown.push(
        `Day${currentDay !== endDay ? `s ${currentDay}-${endDay}` : ` ${currentDay}`}: ${weakAreas[i].topic} ${i === 0 ? "fundamentals" : "practice"}`
      );
      
      currentDay = endDay + 1;
    }

    if (currentDay <= days) {
      breakdown.push(`Day${currentDay !== days ? `s ${currentDay}-${days}` : ` ${days}`}: Mixed review`);
    }

    return breakdown;
  }

  /**
   * Store coaching messages in database
   */
  async storeCoachingMessages(userId: string, messages: CoachingMessageData[]): Promise<void> {
    // Clear expired messages first
    await this.clearExpiredMessages();

    // Clear existing active messages for this user to prevent duplicates
    await prisma.coachingMessage.deleteMany({
      where: {
        userId,
        status: "active",
      },
    });

    // Store new messages
    for (const msg of messages) {
      const expiresAt = this.calculateExpiration(msg.type);
      
      await prisma.coachingMessage.create({
        data: {
          userId,
          type: msg.type,
          priority: msg.priority,
          title: msg.title,
          content: msg,
          status: "active",
          expiresAt,
        },
      });
    }
  }

  /**
   * Calculate expiration time based on message type
   */
  private calculateExpiration(type: string): Date {
    const now = new Date();
    
    switch (type) {
      case "momentum":
        // Momentum opportunities expire in 2 hours
        return new Date(now.getTime() + 2 * 60 * 60 * 1000);
      
      case "exam_prep":
        // Exam prep messages expire in 24 hours (new one generated daily)
        return new Date(now.getTime() + 24 * 60 * 60 * 1000);
      
      case "drift_recovery":
        // Drift recovery expires in 12 hours
        return new Date(now.getTime() + 12 * 60 * 60 * 1000);
      
      case "consistency":
        // Consistency messages last 7 days
        return new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
      
      default:
        return new Date(now.getTime() + 24 * 60 * 60 * 1000);
    }
  }

  /**
   * Clear expired messages
   */
  async clearExpiredMessages(): Promise<void> {
    await prisma.coachingMessage.deleteMany({
      where: {
        expiresAt: { lt: new Date() },
      },
    });
  }

  /**
   * Get active coaching messages for a user
   */
  async getActiveMessages(userId: string): Promise<any[]> {
    return prisma.coachingMessage.findMany({
      where: {
        userId,
        status: "active",
        expiresAt: { gt: new Date() },
      },
      orderBy: [
        { priority: "asc" }, // high first
        { createdAt: "desc" },
      ],
    });
  }

  /**
   * Dismiss a coaching message
   */
  async dismissMessage(messageId: string): Promise<void> {
    await prisma.coachingMessage.update({
      where: { id: messageId },
      data: { status: "dismissed" },
    });
  }

  /**
   * Mark a message as completed (user acted on it)
   */
  async completeMessage(messageId: string, actionType: string): Promise<void> {
    await prisma.coachingMessage.update({
      where: { id: messageId },
      data: {
        status: "completed",
        readAt: new Date(),
      },
    });

    // TODO: Track which action was taken for analytics
    console.log(`✅ Coaching action completed: ${actionType} for message ${messageId}`);
  }
}

export const coachingService = new CoachingService();

