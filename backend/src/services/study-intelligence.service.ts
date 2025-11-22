// backend/src/services/study-intelligence.service.ts
// 🧠 STUDY INTELLIGENCE - Adapted from memory-intelligence for academic domination
// KEEPS ALL PATTERN DETECTION POWER, redirected to study behavior

import { prisma } from "../utils/db";
import { memoryService } from "./memory.service";
import { semanticMemory } from "./semanticMemory.service";
import OpenAI from "openai";

const OPENAI_MODEL = process.env.OPENAI_MODEL || "gpt-4o";

function getOpenAIClient() {
  if (process.env.NODE_ENV === "build" || process.env.RAILWAY_ENVIRONMENT === "build") return null;
  if (!process.env.OPENAI_API_KEY) return null;
  return new OpenAI({ apiKey: process.env.OPENAI_API_KEY.trim() });
}

export type AIPhase = "observer" | "architect" | "oracle";

export interface TimeWindow {
  time: string;
  description: string;
  frequency: number;
  effectiveness?: number; // avg effectiveness during this window
}

export interface Protocol {
  text: string;
  worked_count: number;
  last_used: Date;
}

export interface StudyPatterns {
  peak_study_windows: TimeWindow[];
  drift_windows: TimeWindow[];
  consistency_score: number;
  procrastination_triggers: string[];
  return_protocols: Protocol[];
  average_session_minutes: number;
  best_subjects: string[];
  struggle_subjects: string[];
  optimal_session_length: number;
  last_analyzed: Date;
}

export interface ExamThreat {
  examId: string;
  subject: string;
  topic: string | null;
  date: Date;
  daysRemaining: number;
  threatLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW";
  currentProgress: number;
  prediction: string;
  gapAnalysis: string[];
  recommendedHours: number;
}

export interface OSPhase {
  current_phase: AIPhase;
  started_at: Date;
  days_in_phase: number;
  phase_transitions: Array<{ from: AIPhase; to: AIPhase; at: Date }>;
}

export interface SemanticThreads {
  recurringExcuses: string[];
  timeWasters: string[];
  studyContradictions: string[];
  recentBreakthroughs: string[];
  commonMistakes: string[];
}

export interface StudyConsciousness {
  identity: {
    name: string;
    grade: string | null;
    studyGoals: string[];
    learningStyle: string | null;
    createdAt: Date;
  };

  patterns: StudyPatterns;

  exams: ExamThreat[];
  examProximity: "CRITICAL" | "HIGH" | "MEDIUM" | "NONE";

  topicMastery: Record<string, number>;
  weakTopics: string[];
  strongTopics: string[];
  stuckTopics: string[];

  recentSessions: any[];
  todayMinutes: number;
  weeklyMinutes: number;
  weeklyTarget: number;

  semanticThreads: SemanticThreads;

  phase: AIPhase;
  os_phase: OSPhase;
  tone: string;
  nextEvolution: string;

  currentStreak: number;
  longestStreak: number;
  totalStudyHours: number;
}

export class StudyIntelligenceService {
  // ============================================================
  // 🧠 Build Study Consciousness (ADAPTED from buildUserConsciousness)
  // ============================================================
  async buildStudyConsciousness(userId: string): Promise<StudyConsciousness> {
    const [user, facts, identity, exams, recentSessions, mastery] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId } }),
      prisma.userFacts.findUnique({ where: { userId } }),
      memoryService.getIdentityFacts(userId),
      prisma.exam.findMany({
        where: { userId },
        orderBy: { date: "asc" },
      }),
      this.getRecentSessions(userId, 30),
      prisma.topicMastery.findMany({ where: { userId } }),
    ]);

    const factsData = (facts?.json as any) || {};
    const createdAt = user?.createdAt || new Date();

    // Build study identity
    const studyIdentity = {
      name: identity.name,
      grade: user?.grade || null,
      studyGoals: user?.studyGoals || [],
      learningStyle: user?.learningStyle || null,
      createdAt,
    };

    // REUSE phase determination logic
    const os_phase = this.getOrInitializePhase(factsData, createdAt);
    const phase = this.determinePhase(factsData, identity, createdAt);

    // Extract study patterns (ADAPTED from extractPatternsFromEvents)
    const patterns = factsData.studyPatterns || await this.extractStudyPatterns(userId, recentSessions);

    // Calculate exam threats
    const examThreats = this.calculateExamThreats(exams, mastery);
    const examProximity = this.getExamProximity(examThreats);

    // Build mastery maps
    const topicMasteryMap = this.buildMasteryMap(mastery);
    const weakTopics = mastery.filter((m) => m.score < 50).map((m) => m.topic);
    const strongTopics = mastery.filter((m) => m.score > 75).map((m) => m.topic);
    const stuckTopics = this.findStuckTopics(mastery, recentSessions);

    // Build semantic threads (REUSE logic, study events)
    const semanticThreads = await this.buildStudySemanticThreads(userId);

    // Calculate streaks and totals
    const streakData = this.calculateStudyStreaks(recentSessions);

    // Calculate time stats
    const todayMinutes = this.getTodayMinutes(recentSessions);
    const weeklyMinutes = this.getWeeklyMinutes(recentSessions);

    return {
      identity: studyIdentity,
      patterns,
      exams: examThreats,
      examProximity,
      topicMastery: topicMasteryMap,
      weakTopics,
      strongTopics,
      stuckTopics,
      recentSessions: recentSessions.slice(0, 10),
      todayMinutes,
      weeklyMinutes,
      weeklyTarget: user?.weeklyGoal || 600,
      semanticThreads,
      phase,
      os_phase,
      tone: user?.tone || "balanced",
      nextEvolution: this.predictNextGrowth(patterns, examThreats),
      currentStreak: streakData.current,
      longestStreak: streakData.longest,
      totalStudyHours: streakData.totalHours,
    };
  }

  // ============================================================
  // 🔥 Extract Study Patterns (ADAPTED from extractPatternsFromEvents)
  // ============================================================
  async extractStudyPatterns(userId: string, sessions: any[]): Promise<StudyPatterns> {
    const peak_study_windows = this.findPeakStudyWindows(sessions);
    const drift_windows = this.findDriftWindows(sessions);
    const consistency_score = await this.calculateConsistency(userId, sessions);
    const procrastination_triggers = await this.detectProcrastinationTriggers(userId);
    const return_protocols = await this.extractReturnProtocols(userId);

    const avg_minutes =
      sessions.length > 0
        ? sessions.reduce((sum, s) => sum + s.minutes, 0) / sessions.length
        : 0;

    const subjectPerformance = this.analyzeSubjectPerformance(sessions);
    const optimal_length = this.findOptimalSessionLength(sessions);

    const patterns: StudyPatterns = {
      peak_study_windows,
      drift_windows,
      consistency_score,
      procrastination_triggers,
      return_protocols,
      average_session_minutes: Math.round(avg_minutes),
      best_subjects: subjectPerformance.best,
      struggle_subjects: subjectPerformance.struggles,
      optimal_session_length: optimal_length,
      last_analyzed: new Date(),
    };

    // Store back in UserFacts
    await memoryService.upsertFacts(userId, { studyPatterns: patterns });

    return patterns;
  }

  // ============================================================
  // 🧵 Build Study Semantic Threads (REUSE semantic memory logic)
  // ============================================================
  private async buildStudySemanticThreads(userId: string): Promise<SemanticThreads> {
    try {
      const recentMemories = await semanticMemory.getRecentMemories({
        userId,
        limit: 30,
      });

      if (recentMemories.length === 0) {
        return {
          recurringExcuses: [],
          timeWasters: [],
          studyContradictions: [],
          recentBreakthroughs: [],
          commonMistakes: [],
        };
      }

      // REUSE existing pattern detection (same algorithm, study keywords)
      const recurringExcuses = this.extractRecurringPhrases(
        recentMemories.map((m) => m.text),
        [
          "didn't understand",
          "too hard",
          "too difficult",
          "confused",
          "not enough time",
          "will do later",
          "tomorrow",
          "didn't feel like it",
          "wasn't in the mood",
        ]
      );

      const timeWasters = this.extractRecurringPhrases(
        recentMemories.map((m) => m.text),
        [
          "scroll",
          "scrolling",
          "youtube",
          "tiktok",
          "instagram",
          "social media",
          "netflix",
          "gaming",
          "game",
          "binge",
          "doom",
          "wasted time",
          "distracted",
        ]
      );

      const studyContradictions = this.detectContradictoryPatterns(recentMemories);
      const breakthroughs = this.extractBreakthroughs(recentMemories);
      const mistakes = this.extractCommonMistakes(recentMemories);

      return {
        recurringExcuses,
        timeWasters,
        studyContradictions,
        recentBreakthroughs: breakthroughs,
        commonMistakes: mistakes,
      };
    } catch (err) {
      console.warn("⚠️ Failed to build study semantic threads:", err);
      return {
        recurringExcuses: [],
        timeWasters: [],
        studyContradictions: [],
        recentBreakthroughs: [],
        commonMistakes: [],
      };
    }
  }

  // ============================================================
  // 🎯 Calculate Exam Threats
  // ============================================================
  calculateExamThreats(exams: any[], mastery: any[]): ExamThreat[] {
    const now = new Date();

    return exams.map((exam) => {
      const daysRemaining = Math.ceil(
        (new Date(exam.date).getTime() - now.getTime()) / (1000 * 60 * 60 * 24)
      );

      // Find relevant topic mastery scores
      const relevantTopics = mastery.filter(
        (m) =>
          m.subject === exam.subject &&
          (exam.topic ? m.topic.toLowerCase().includes(exam.topic.toLowerCase()) : true)
      );

      const avgMastery =
        relevantTopics.length > 0
          ? relevantTopics.reduce((sum, t) => sum + t.score, 0) / relevantTopics.length
          : 0;

      // Calculate progress (mastery + time factor)
      const timeFactor = daysRemaining > 0 ? Math.min(30, (30 / daysRemaining) * 10) : 0;
      const progress = Math.min(100, Math.round(avgMastery * 0.7 + timeFactor));

      // Predict exam outcome
      const prediction = this.predictExamOutcome(avgMastery, daysRemaining, exam.weight);

      // Determine threat level
      let threatLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW";
      if (daysRemaining <= 5 && avgMastery < 60) threatLevel = "CRITICAL";
      else if (daysRemaining <= 7 || avgMastery < 50) threatLevel = "HIGH";
      else if (daysRemaining <= 14 || avgMastery < 70) threatLevel = "MEDIUM";
      else threatLevel = "LOW";

      // Gap analysis (weak topics for this exam)
      const gapAnalysis = relevantTopics
        .filter((t) => t.score < 60)
        .map((t) => `${t.topic} (${t.score}%)`);

      // Calculate required study hours
      const hoursNeeded = this.calculateRequiredHours(avgMastery, 80, daysRemaining);

      return {
        examId: exam.id,
        subject: exam.subject,
        topic: exam.topic,
        date: exam.date,
        daysRemaining: Math.max(0, daysRemaining),
        threatLevel,
        currentProgress: progress,
        prediction,
        gapAnalysis,
        recommendedHours: hoursNeeded,
      };
    });
  }

  // ============================================================
  // 🎲 Predict Exam Outcome
  // ============================================================
  private predictExamOutcome(
    currentMastery: number,
    daysRemaining: number,
    weight: number
  ): string {
    // Base prediction on current mastery
    let predicted = currentMastery;

    // Adjust for time remaining
    if (daysRemaining > 14) {
      predicted += 10; // room for improvement
    } else if (daysRemaining < 3) {
      predicted -= 5; // stress penalty
    }

    // Clamp to 0-100
    predicted = Math.max(0, Math.min(100, predicted));

    // Convert to grade if makes sense
    if (predicted >= 90) return "A+ (90-100%)";
    if (predicted >= 80) return "A (80-89%)";
    if (predicted >= 70) return "B (70-79%)";
    if (predicted >= 60) return "C (60-69%)";
    if (predicted >= 50) return "D (50-59%)";
    return "F (<50%)";
  }

  // ============================================================
  // 📊 Calculate Required Hours
  // ============================================================
  private calculateRequiredHours(
    currentMastery: number,
    targetMastery: number,
    daysRemaining: number
  ): number {
    const gap = targetMastery - currentMastery;
    if (gap <= 0) return 0;

    // Rough heuristic: 1% mastery = 30 minutes of focused study
    const totalMinutesNeeded = gap * 30;
    const totalHours = Math.ceil(totalMinutesNeeded / 60);

    // Spread over remaining days
    if (daysRemaining > 0) {
      return Math.ceil(totalHours / daysRemaining);
    }

    return totalHours;
  }

  // ============================================================
  // 🔍 Get Exam Proximity
  // ============================================================
  getExamProximity(threats: ExamThreat[]): "CRITICAL" | "HIGH" | "MEDIUM" | "NONE" {
    if (threats.length === 0) return "NONE";

    const criticalCount = threats.filter((t) => t.threatLevel === "CRITICAL").length;
    if (criticalCount > 0) return "CRITICAL";

    const highCount = threats.filter((t) => t.threatLevel === "HIGH").length;
    if (highCount > 0) return "HIGH";

    const mediumCount = threats.filter((t) => t.threatLevel === "MEDIUM").length;
    if (mediumCount > 0) return "MEDIUM";

    return "NONE";
  }

  // ============================================================
  // 📈 Find Peak Study Windows (when they're most effective)
  // ============================================================
  private findPeakStudyWindows(sessions: any[]): TimeWindow[] {
    const hours: Record<number, { total: number; effectiveness: number[] }> = {};

    for (const s of sessions) {
      const h = new Date(s.createdAt).getHours();
      if (!hours[h]) hours[h] = { total: 0, effectiveness: [] };
      hours[h].total++;
      if (s.effectiveness) hours[h].effectiveness.push(s.effectiveness);
    }

    return Object.entries(hours)
      .map(([hourStr, data]) => {
        if (data.total < 2) return null; // need at least 2 sessions
        
        const avgEff =
          data.effectiveness.length > 0
            ? data.effectiveness.reduce((a, b) => a + b, 0) / data.effectiveness.length
            : 0;

        if (avgEff >= 7 || data.total >= 5) {
          return {
            time: `${hourStr}:00`,
            description: `High productivity (${data.total} sessions, ${avgEff.toFixed(1)}/10 avg)`,
            frequency: data.total,
            effectiveness: avgEff,
          };
        }
        return null;
      })
      .filter(Boolean)
      .sort((a: any, b: any) => (b.effectiveness || 0) - (a.effectiveness || 0))
      .slice(0, 3) as TimeWindow[];
  }

  // ============================================================
  // 📉 Find Drift Windows (when they plan but don't study)
  // ============================================================
  private findDriftWindows(sessions: any[]): TimeWindow[] {
    // Look for gaps in expected study times
    const sessionHours = sessions.map((s) => new Date(s.createdAt).getHours());
    const hourCounts: Record<number, number> = {};

    for (const h of sessionHours) {
      hourCounts[h] = (hourCounts[h] || 0) + 1;
    }

    // Detect common "should study" hours with low activity
    const expectedStudyHours = [9, 10, 14, 15, 16, 19, 20]; // common study times
    const drifts: TimeWindow[] = [];

    for (const hour of expectedStudyHours) {
      const count = hourCounts[hour] || 0;
      const avgCount = Object.values(hourCounts).reduce((a, b) => a + b, 0) / Object.keys(hourCounts).length;

      // If this hour has significantly less activity than average
      if (count < avgCount * 0.5) {
        drifts.push({
          time: `${hour}:00`,
          description: `Low study activity (${count} sessions vs ${avgCount.toFixed(1)} avg)`,
          frequency: count,
        });
      }
    }

    return drifts.slice(0, 3);
  }

  // ============================================================
  // 📊 Calculate Consistency
  // ============================================================
  private async calculateConsistency(userId: string, sessions: any[]): Promise<number> {
    if (sessions.length === 0) return 0;

    const weeklyGoal = (await prisma.user.findUnique({ where: { id: userId } }))?.weeklyGoal || 600;
    const weeklyMinutes = this.getWeeklyMinutes(sessions);

    // Consistency = (actual / goal) * 100, capped at 100
    return Math.min(100, Math.round((weeklyMinutes / weeklyGoal) * 100));
  }

  // ============================================================
  // 🚫 Detect Procrastination Triggers (from semantic memory)
  // ============================================================
  private async detectProcrastinationTriggers(userId: string): Promise<string[]> {
    try {
      const memories = await semanticMemory.getRecentMemories({ userId, limit: 20 });
      
      const triggers = this.extractRecurringPhrases(
        memories.map((m) => m.text),
        [
          "youtube",
          "tiktok",
          "instagram",
          "social media",
          "gaming",
          "netflix",
          "scrolling",
          "phone",
          "distracted",
        ]
      );

      return triggers;
    } catch {
      return [];
    }
  }

  // ============================================================
  // 🔄 Extract Return Protocols (what helps them refocus)
  // ============================================================
  private async extractReturnProtocols(userId: string): Promise<Protocol[]> {
    const events = await prisma.event.findMany({
      where: {
        userId,
        type: { in: ["chat_message", "study_session_complete", "reflection"] },
        ts: { gte: new Date(Date.now() - 30 * 86400000) },
      },
      orderBy: { ts: "desc" },
      take: 50,
    });

    const protocols: Protocol[] = [];

    for (const e of events) {
      const text = (e.payload as any)?.text || (e.payload as any)?.notes || "";
      const lower = text.toLowerCase();

      // Look for mentions of what worked
      if (
        lower.includes("pomodoro") ||
        lower.includes("timer") ||
        lower.includes("music") ||
        lower.includes("library") ||
        lower.includes("coffee shop") ||
        lower.includes("study group")
      ) {
        protocols.push({
          text: text.slice(0, 100),
          worked_count: 1,
          last_used: e.ts,
        });
      }
    }

    return protocols.slice(0, 5);
  }

  // ============================================================
  // 📚 Analyze Subject Performance
  // ============================================================
  private analyzeSubjectPerformance(sessions: any[]): {
    best: string[];
    struggles: string[];
  } {
    const subjectData: Record<string, { minutes: number; count: number; effectiveness: number[] }> =
      {};

    for (const s of sessions) {
      if (!subjectData[s.subject]) {
        subjectData[s.subject] = { minutes: 0, count: 0, effectiveness: [] };
      }
      subjectData[s.subject].minutes += s.minutes;
      subjectData[s.subject].count++;
      if (s.effectiveness) subjectData[s.subject].effectiveness.push(s.effectiveness);
    }

    const subjects = Object.entries(subjectData).map(([subject, data]) => ({
      subject,
      avgEffectiveness:
        data.effectiveness.length > 0
          ? data.effectiveness.reduce((a, b) => a + b, 0) / data.effectiveness.length
          : 5,
      totalMinutes: data.minutes,
    }));

    subjects.sort((a, b) => b.avgEffectiveness - a.avgEffectiveness);

    return {
      best: subjects.slice(0, 3).map((s) => s.subject),
      struggles: subjects.slice(-3).map((s) => s.subject).reverse(),
    };
  }

  // ============================================================
  // 🎯 Find Stuck Topics (studied multiple times, no improvement)
  // ============================================================
  private findStuckTopics(mastery: any[], sessions: any[]): string[] {
    const stuck: string[] = [];

    for (const m of mastery) {
      // Sessions for this topic
      const topicSessions = sessions.filter(
        (s) => s.subject === m.subject && s.topic && s.topic.toLowerCase().includes(m.topic.toLowerCase())
      );

      // If studied 3+ times but mastery still < 60%
      if (topicSessions.length >= 3 && m.score < 60) {
        stuck.push(m.topic);
      }
    }

    return stuck.slice(0, 5);
  }

  // ============================================================
  // 📊 Build Mastery Map
  // ============================================================
  private buildMasteryMap(mastery: any[]): Record<string, number> {
    const map: Record<string, number> = {};
    for (const m of mastery) {
      map[`${m.subject} - ${m.topic}`] = m.score;
    }
    return map;
  }

  // ============================================================
  // ⏱️ Calculate Study Streaks
  // ============================================================
  private calculateStudyStreaks(sessions: any[]): {
    current: number;
    longest: number;
    totalHours: number;
  } {
    if (sessions.length === 0) {
      return { current: 0, longest: 0, totalHours: 0 };
    }

    // Sort by date desc
    const sorted = [...sessions].sort(
      (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );

    const totalMinutes = sessions.reduce((sum, s) => sum + s.minutes, 0);

    // Calculate current streak (consecutive days with sessions)
    let currentStreak = 0;
    let checkDate = new Date();
    checkDate.setHours(0, 0, 0, 0);

    const sessionDates = new Set(
      sorted.map((s) => {
        const d = new Date(s.createdAt);
        d.setHours(0, 0, 0, 0);
        return d.getTime();
      })
    );

    while (sessionDates.has(checkDate.getTime())) {
      currentStreak++;
      checkDate.setDate(checkDate.getDate() - 1);
    }

    // Calculate longest streak (would need historical data, estimate from current)
    const longestStreak = Math.max(currentStreak, Math.floor(sessions.length / 7));

    return {
      current: currentStreak,
      longest: longestStreak,
      totalHours: Math.round(totalMinutes / 60),
    };
  }

  // ============================================================
  // 📅 Time Calculations
  // ============================================================
  private getTodayMinutes(sessions: any[]): number {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return sessions
      .filter((s) => new Date(s.createdAt) >= today)
      .reduce((sum, s) => sum + s.minutes, 0);
  }

  private getWeeklyMinutes(sessions: any[]): number {
    const weekAgo = new Date(Date.now() - 7 * 86400000);

    return sessions
      .filter((s) => new Date(s.createdAt) >= weekAgo)
      .reduce((sum, s) => sum + s.minutes, 0);
  }

  // ============================================================
  // 🔍 Find Optimal Session Length
  // ============================================================
  private findOptimalSessionLength(sessions: any[]): number {
    const sessionsWithRating = sessions.filter((s) => s.effectiveness);

    if (sessionsWithRating.length === 0) return 45; // default

    // Group by duration buckets
    const buckets: Record<string, { count: number; effectiveness: number[] }> = {
      short: { count: 0, effectiveness: [] }, // < 30 min
      medium: { count: 0, effectiveness: [] }, // 30-60 min
      long: { count: 0, effectiveness: [] }, // > 60 min
    };

    for (const s of sessionsWithRating) {
      const bucket = s.minutes < 30 ? "short" : s.minutes <= 60 ? "medium" : "long";
      buckets[bucket].count++;
      buckets[bucket].effectiveness.push(s.effectiveness);
    }

    // Find bucket with highest avg effectiveness
    const bucketAvgs = Object.entries(buckets).map(([bucket, data]) => ({
      bucket,
      avg:
        data.effectiveness.length > 0
          ? data.effectiveness.reduce((a, b) => a + b, 0) / data.effectiveness.length
          : 0,
    }));

    bucketAvgs.sort((a, b) => b.avg - a.avg);
    const best = bucketAvgs[0].bucket;

    if (best === "short") return 25;
    if (best === "long") return 90;
    return 45; // medium
  }

  // ============================================================
  // 🎭 Determine Phase (REUSE existing logic)
  // ============================================================
  determinePhase(factsData: any, identity: any, createdAt: Date): AIPhase {
    const days = Math.floor((Date.now() - createdAt.getTime()) / 86400000);

    const studyDepth = factsData.studyPatterns?.consistency_score || 0;
    const current = factsData.os_phase?.current_phase;

    // OBSERVER: First 2 weeks, learning patterns
    if (days < 14) return "observer";

    // ARCHITECT: Building study systems (2-8 weeks, consistency > 50%)
    if (current === "architect" || (days >= 14 && studyDepth >= 50)) {
      if (current === "architect") {
        const daysInPhase = factsData.os_phase?.days_in_phase || 0;
        const consistency = factsData.studyPatterns?.consistency_score || 0;

        // Transition to Oracle after 30+ days with 70%+ consistency
        if (daysInPhase >= 30 && consistency >= 70) return "oracle";
      }
      return "architect";
    }

    // ORACLE: Mastery mode (8+ weeks, high consistency)
    if (current === "oracle" || (days >= 56 && studyDepth >= 70)) return "oracle";

    return current || "observer";
  }

  // ============================================================
  // 📈 Predict Next Growth
  // ============================================================
  predictNextGrowth(patterns: StudyPatterns, exams: ExamThreat[]): string {
    // Critical exam coming
    const criticalExam = exams.find((e) => e.threatLevel === "CRITICAL");
    if (criticalExam) return "exam_crisis_mode";

    // High consistency but stuck topics
    if (patterns.consistency_score > 70 && patterns.struggle_subjects.length > 2) {
      return "overcome_weak_subjects";
    }

    // Low consistency
    if (patterns.consistency_score < 50) return "build_study_routine";

    // Many drift windows
    if (patterns.drift_windows.length > 2) return "eliminate_distractions";

    return "maintain_momentum";
  }

  // ============================================================
  // 🔧 Helper: Get or Initialize Phase
  // ============================================================
  private getOrInitializePhase(factsData: any, createdAt: Date): OSPhase {
    if (factsData.os_phase) {
      const days = Math.floor(
        (Date.now() - new Date(factsData.os_phase.started_at).getTime()) / 86400000
      );
      return { ...factsData.os_phase, days_in_phase: days };
    }

    return {
      current_phase: "observer",
      started_at: createdAt,
      days_in_phase: Math.floor((Date.now() - createdAt.getTime()) / 86400000),
      phase_transitions: [],
    };
  }

  // ============================================================
  // 📚 Get Recent Sessions
  // ============================================================
  private async getRecentSessions(userId: string, days: number): Promise<any[]> {
    const since = new Date(Date.now() - days * 86400000);

    return prisma.studySession.findMany({
      where: {
        userId,
        createdAt: { gte: since },
      },
      orderBy: { createdAt: "desc" },
    });
  }

  // ============================================================
  // 🔍 Pattern Detection Helpers (REUSED from memory-intelligence)
  // ============================================================
  private extractRecurringPhrases(texts: string[], keywords: string[]): string[] {
    const found: Record<string, number> = {};

    for (const text of texts) {
      const lower = text.toLowerCase();
      for (const keyword of keywords) {
        if (lower.includes(keyword)) {
          found[keyword] = (found[keyword] || 0) + 1;
        }
      }
    }

    return Object.entries(found)
      .filter(([, count]) => count >= 2)
      .sort(([, a], [, b]) => b - a)
      .map(([phrase]) => phrase)
      .slice(0, 5);
  }

  private detectContradictoryPatterns(memories: any[]): string[] {
    const contradictions: string[] = [];
    const texts = memories.map((m) => m.text);

    for (const text of texts) {
      const lower = text.toLowerCase();
      if (
        (lower.includes("want") || lower.includes("need") || lower.includes("goal")) &&
        (lower.includes("but") || lower.includes("didn't") || lower.includes("missed"))
      ) {
        const snippet = text.substring(0, 80) + (text.length > 80 ? "..." : "");
        contradictions.push(snippet);
        if (contradictions.length >= 3) break;
      }
    }

    return contradictions;
  }

  private extractBreakthroughs(memories: any[]): string[] {
    const breakthroughs: string[] = [];

    const positiveKeywords = [
      "finally understood",
      "clicked",
      "makes sense now",
      "breakthrough",
      "got it",
      "aha",
    ];

    for (const m of memories) {
      const lower = m.text.toLowerCase();
      for (const keyword of positiveKeywords) {
        if (lower.includes(keyword)) {
          breakthroughs.push(m.text.substring(0, 100));
          break;
        }
      }
      if (breakthroughs.length >= 3) break;
    }

    return breakthroughs;
  }

  private extractCommonMistakes(memories: any[]): string[] {
    const mistakes: string[] = [];

    const mistakeKeywords = [
      "keep getting wrong",
      "same mistake",
      "always forget",
      "confused about",
      "can't remember",
    ];

    for (const m of memories) {
      const lower = m.text.toLowerCase();
      for (const keyword of mistakeKeywords) {
        if (lower.includes(keyword)) {
          mistakes.push(m.text.substring(0, 100));
          break;
        }
      }
      if (mistakes.length >= 3) break;
    }

    return mistakes;
  }

  // ============================================================
  // 🔄 Update Mastery from Session
  // ============================================================
  async updateMasteryFromSession(session: any): Promise<void> {
    if (!session.topic) return;

    const existing = await prisma.topicMastery.findUnique({
      where: {
        userId_subject_topic: {
          userId: session.userId,
          subject: session.subject,
          topic: session.topic,
        },
      },
    });

    if (existing) {
      // Update existing mastery
      const newSessions = existing.sessionsCount + 1;
      const newMinutes = existing.totalMinutes + session.minutes;

      // Increase mastery based on session effectiveness
      let scoreDelta = 0;
      if (session.effectiveness) {
        scoreDelta = Math.round((session.effectiveness - 5) * 1.5); // -7.5 to +7.5
      } else {
        scoreDelta = 2; // default small increase
      }

      const newScore = Math.max(0, Math.min(100, existing.score + scoreDelta));

      await prisma.topicMastery.update({
        where: { id: existing.id },
        data: {
          score: newScore,
          lastStudied: session.createdAt,
          totalMinutes: newMinutes,
          sessionsCount: newSessions,
        },
      });

      // Log mastery milestone if crossed threshold
      if (newScore >= 75 && existing.score < 75) {
        await prisma.event.create({
          data: {
            userId: session.userId,
            type: "topic_mastered",
            payload: { subject: session.subject, topic: session.topic, score: newScore },
          },
        });
      } else if (newScore < 50 && newSessions >= 3) {
        await prisma.event.create({
          data: {
            userId: session.userId,
            type: "weakness_identified",
            payload: { subject: session.subject, topic: session.topic, attempts: newSessions },
          },
        });
      }
    } else {
      // Create new mastery entry
      const initialScore = session.effectiveness
        ? Math.round(session.effectiveness * 5) // 1-10 → 5-50
        : 25;

      await prisma.topicMastery.create({
        data: {
          userId: session.userId,
          subject: session.subject,
          topic: session.topic,
          score: initialScore,
          confidence: session.effectiveness ? session.effectiveness * 10 : 50,
          lastStudied: session.createdAt,
          totalMinutes: session.minutes,
          sessionsCount: 1,
        },
      });
    }
  }

  // ============================================================
  // 🔄 Recalculate Exam Threats (called after sessions/mastery updates)
  // ============================================================
  async recalculateExamThreats(userId: string): Promise<void> {
    const [exams, mastery] = await Promise.all([
      prisma.exam.findMany({ where: { userId } }),
      prisma.topicMastery.findMany({ where: { userId } }),
    ]);

    const threats = this.calculateExamThreats(exams, mastery);

    // Update each exam with new calculations
    for (const threat of threats) {
      await prisma.exam.update({
        where: { id: threat.examId },
        data: {
          daysRemaining: threat.daysRemaining,
          threatLevel: threat.threatLevel,
          progress: threat.currentProgress,
          prediction: threat.prediction,
        },
      });
    }
  }
}

export const studyIntelligence = new StudyIntelligenceService();

