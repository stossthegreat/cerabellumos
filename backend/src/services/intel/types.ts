// backend/src/services/intel/types.ts
// 🧠 Unified Intelligence State Types

export interface ExamThreatSnapshot {
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

export interface TimeWindow {
  time: string;
  description: string;
  frequency: number;
  effectiveness?: number;
}

export interface Protocol {
  text: string;
  worked_count: number;
  last_used: Date;
}

export interface StudyPatternSnapshot {
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

export interface SemanticThread {
  recurringExcuses: string[];
  timeWasters: string[];
  studyContradictions: string[];
  recentBreakthroughs: string[];
  commonMistakes: string[];
}

export interface MasteryMap {
  topicScores: Record<string, number>;
  weakTopics: string[];
  strongTopics: string[];
  stuckTopics: string[];
}

export interface UserIdentitySnapshot {
  archetype: string;
  archetypeIcon: string;
  confidence: number;
  direction: string;
  directionTrend: "up" | "down" | "stable";
  drivers: string[];
  riskTag: "Safe" | "At Risk" | "Red Zone Before Exam";
  currentState: string;
  targetState: string;
  evolutionProgress: number;
  lastChange: string;
}

export interface UserIntelState {
  identity: UserIdentitySnapshot;
  exams: ExamThreatSnapshot[];
  examProximity: "CRITICAL" | "HIGH" | "MEDIUM" | "NONE";
  studyPatterns: StudyPatternSnapshot;
  mastery: MasteryMap;
  semanticThreads: SemanticThread;
  recentSessions: any[];
  todayMinutes: number;
  weeklyMinutes: number;
  weeklyTarget: number;
}

