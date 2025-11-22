// backend/src/services/intel/buildUserIntelState.ts
// 🧠 Unified Intelligence State Builder

import { UserIntelState, ExamThreatSnapshot, StudyPatternSnapshot, SemanticThread, MasteryMap } from "./types";
import { studyIntelligence } from "../study-intelligence.service";
import { prisma } from "../../utils/db";
import { computeIdentity } from "./identity-engine/computeIdentity";

export async function buildUserIntelState(userId: string): Promise<UserIntelState> {
  // Load all intelligence data in parallel
  const [
    exams,
    mastery,
    recentSessions,
    user,
  ] = await Promise.all([
    prisma.exam.findMany({
      where: { userId },
      orderBy: { date: "asc" },
    }),
    prisma.topicMastery.findMany({ where: { userId } }),
    prisma.studySession.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: 30,
    }),
    prisma.user.findUnique({ where: { id: userId } }),
  ]);

  // Calculate exam threats
  const examThreats: ExamThreatSnapshot[] = studyIntelligence.calculateExamThreats(exams, mastery);
  const examProximity = studyIntelligence.getExamProximity(examThreats);

  // Extract study patterns
  const patterns: StudyPatternSnapshot = await studyIntelligence.extractStudyPatterns(userId, recentSessions);

  // Build semantic threads - use empty default for now as method is private
  const threads: SemanticThread = {
    recurringExcuses: [],
    timeWasters: [],
    studyContradictions: [],
    recentBreakthroughs: [],
    commonMistakes: [],
  };

  // Build mastery map
  const topicScores: Record<string, number> = {};
  mastery.forEach((m) => {
    topicScores[m.topic] = m.score;
  });

  const masteryMap: MasteryMap = {
    topicScores,
    weakTopics: mastery.filter((m) => m.score < 50).map((m) => m.topic),
    strongTopics: mastery.filter((m) => m.score > 75).map((m) => m.topic),
    stuckTopics: [], // Method is private, compute manually if needed
  };

  // Compute identity
  const identity = await computeIdentity(patterns, examThreats, masteryMap, threads, recentSessions);

  // Calculate session stats
  const now = new Date();
  const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const weekStart = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  const todayMinutes = recentSessions
    .filter((s) => new Date(s.createdAt) >= todayStart)
    .reduce((sum, s) => sum + (s.minutes || 0), 0);

  const weeklyMinutes = recentSessions
    .filter((s) => new Date(s.createdAt) >= weekStart)
    .reduce((sum, s) => sum + (s.minutes || 0), 0);

  const weeklyTarget = user?.weeklyGoal || 1200; // 20 hours default

  return {
    identity,
    exams: examThreats,
    examProximity,
    studyPatterns: patterns,
    mastery: masteryMap,
    semanticThreads: threads,
    recentSessions,
    todayMinutes,
    weeklyMinutes,
    weeklyTarget,
  };
}

