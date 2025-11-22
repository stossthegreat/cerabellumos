// backend/src/services/intel/identity-engine/rules.ts
// 🎯 Identity Engine Rules

import { StudyPatternSnapshot, ExamThreatSnapshot, MasteryMap } from "../types";

export function detectArchetype(
  patterns: StudyPatternSnapshot,
  mastery: MasteryMap,
  exams: ExamThreatSnapshot[]
): string {
  const consistency = patterns.consistency_score;
  const driftWindows = patterns.drift_windows.length;
  const criticalExams = exams.filter((e) => e.threatLevel === "CRITICAL");
  const avgMastery = Object.values(mastery.topicScores).reduce((a, b) => a + b, 0) / Object.keys(mastery.topicScores).length || 0;

  // Last-Minute Sprinter: critical exam + low prep
  if (criticalExams.length > 0 && avgMastery < 60) {
    return "Last-Minute Sprinter";
  }

  // Avoidant Crammer: high avoidance + exam proximity
  if (
    exams.some((e) => e.daysRemaining < 7) &&
    patterns.procrastination_triggers.length > 3 &&
    avgMastery < 50
  ) {
    return "Avoidant Crammer";
  }

  // Consistent Grinder: high consistency + low drift
  if (consistency > 75 && driftWindows <= 1) {
    return "Consistent Grinder";
  }

  // Momentum Builder: building momentum + increasing consistency
  if (consistency > 55 && consistency < 75 && patterns.average_session_minutes > 30) {
    return "Momentum Builder";
  }

  // Drift Cycler: low consistency + many drift windows (default)
  return "Drift Cycler";
}

export function calculateConfidence(
  patterns: StudyPatternSnapshot,
  sessions: any[]
): number {
  if (sessions.length === 0) return 50;

  const consistencyFactor = patterns.consistency_score * 0.4;
  const sessionFrequencyFactor = Math.min(sessions.length / 30, 1) * 30;
  const peakWindowUsage = patterns.peak_study_windows.length > 0 ? 20 : 0;
  const driftPenalty = patterns.drift_windows.length * 5;

  const confidence = consistencyFactor + sessionFrequencyFactor + peakWindowUsage - driftPenalty;

  return Math.min(100, Math.max(0, Math.round(confidence)));
}

export function determineDirection(
  patterns: StudyPatternSnapshot,
  sessions: any[]
): { direction: string; trend: "up" | "down" | "stable" } {
  const consistency = patterns.consistency_score;
  const recentSessionCount = sessions.filter(
    (s) => new Date(s.createdAt) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
  ).length;

  if (consistency > 70 && recentSessionCount >= 5) {
    return {
      direction: "Becoming more consistent",
      trend: "up",
    };
  }

  if (consistency < 40 || recentSessionCount < 2) {
    return {
      direction: "Losing momentum",
      trend: "down",
    };
  }

  return {
    direction: "Maintaining current pace",
    trend: "stable",
  };
}

export function extractDrivers(
  patterns: StudyPatternSnapshot,
  threads: any
): string[] {
  const drivers: string[] = [];

  // Peak study windows
  if (patterns.peak_study_windows.length > 0) {
    const window = patterns.peak_study_windows[0];
    drivers.push(
      `${window.description} with ${Math.round((window.effectiveness || 0) * 100)}% effectiveness`
    );
  }

  // Best subjects
  if (patterns.best_subjects.length > 0) {
    drivers.push(`Strong performance in ${patterns.best_subjects[0]}`);
  }

  // Consistency
  if (patterns.consistency_score > 60) {
    drivers.push(
      `${Math.round(patterns.average_session_minutes)}-minute average sessions`
    );
  }

  // If not enough drivers, add generic ones
  if (drivers.length === 0) {
    drivers.push("Building study foundation");
    drivers.push("Exploring effective routines");
  }

  return drivers.slice(0, 3);
}

export function assignRiskTag(
  exams: ExamThreatSnapshot[],
  mastery: MasteryMap,
  patterns: StudyPatternSnapshot
): "Safe" | "At Risk" | "Red Zone Before Exam" {
  const criticalExams = exams.filter((e) => e.threatLevel === "CRITICAL");
  const highThreatExams = exams.filter((e) => e.threatLevel === "HIGH");
  const avgMastery = Object.values(mastery.topicScores).reduce((a, b) => a + b, 0) / Object.keys(mastery.topicScores).length || 0;

  // Red Zone: critical exam within 7 days + low mastery
  if (criticalExams.length > 0 && avgMastery < 60) {
    return "Red Zone Before Exam";
  }

  // At Risk: high threat exams or low consistency
  if (highThreatExams.length > 0 || patterns.consistency_score < 40) {
    return "At Risk";
  }

  return "Safe";
}

export function getArchetypeIcon(archetype: string): string {
  switch (archetype) {
    case "Momentum Builder":
      return "🚀";
    case "Drift Cycler":
      return "🌊";
    case "Last-Minute Sprinter":
      return "⚡";
    case "Consistent Grinder":
      return "💪";
    case "Avoidant Crammer":
      return "😰";
    default:
      return "🎯";
  }
}

