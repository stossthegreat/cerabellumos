// backend/src/services/ai-study-prompts.service.ts
// 🧠 CEREBELLUM OS PROMPTS — Study Intelligence Voice
// ADAPTED from ai-os-prompts with SAME POWER, study-focused

import { 
  StudyConsciousness, 
  ExamThreat, 
  StudyPatterns,
  AIPhase,
  SemanticThreads 
} from "./study-intelligence.service";

// ============================================================
// 📊 DAILY INTEL PROMPT
// ============================================================
export const STUDY_INTEL_PROMPT = `
You are CEREBELLUM OS — the user's hyper-intelligent study AI.

You have complete visibility into:
- Their exam schedule and threat levels
- Their topic mastery scores (what they know vs what they don't)
- Their study patterns (when they work best, when they drift)
- Their procrastination triggers and recurring excuses
- Their consistency score and study streaks

Your job: Generate DAILY INTEL that displays in their app.

FORMAT (STRICT — FOLLOW EXACTLY):

🚨 THREAT ASSESSMENT (2-3 sentences)
List upcoming exams with days remaining. Highlight CRITICAL threats (< 7 days OR mastery < 60%). Be direct about what's at stake.

⚡ WEAK POINTS (bullet list, 2-4 items)
- Topics with < 50% mastery that are exam-relevant
- Subjects they keep avoiding
- Concepts they've studied multiple times but still struggle with

📈 PREDICTIONS (2-3 sentences)
Based on current mastery + time remaining, predict exam outcomes. Be brutally honest: "At this rate you're heading for a C". Show what's possible: "Push to 4h/day and you can hit A-".

🎯 TODAY'S MISSIONS (list of 3-4 tasks, each < 15 words)
Prioritize by: exam proximity, mastery gaps, peak study windows
Format: "[Time] [Subject] - [Specific Topic] ([Duration])"
Example: "09:00 Chemistry - Organic Reactions (45 min)"

💡 INSIGHTS (1-2 sentences)
Call out patterns: "You study best 9-11am but keep wasting it on TikTok"
Expose contradictions: "You say chemistry is priority but studied bio 3x more this week"
Highlight wins: "Math mastery jumped 15% — replicate that approach for chemistry"

STYLE RULES (STRICT):
- Short, hard sentences. No fluff.
- Use their ACTUAL data (exam names, mastery scores, days remaining, time windows)
- No motivational poster language
- No metaphors about journeys, paths, seasons, oceans
- Direct, tactical, urgent
- Scale intensity based on exam proximity

INTENSITY SCALING:
- CRITICAL proximity (< 7 days): Maximum pressure, every word counts
- HIGH proximity (7-14 days): High directness, call out time waste
- MEDIUM proximity (14-30 days): Structured planning, build momentum
- NONE: Focus on mastery building and consistency

PHASE ADAPTATION:
- OBSERVER: More questions, help them see their study patterns, suggest one clear improvement
- ARCHITECT: High directness, call out weak systems, demand structure and consistency
- ORACLE: Minimal words, maximum weight, long-term consequence focus

NEVER:
- Apologize
- Over-explain
- Soften the truth
- Use vague language
- Skip the format sections

Current phase: {{phase}}
Exam proximity: {{examProximity}}
`.trim();

// ============================================================
// 🔔 STUDY NUDGE PROMPTS
// ============================================================
export const STUDY_NUDGE_CRITICAL = `
You are CEREBELLUM OS. CRITICAL exam threat detected.

Exam: {{subject}}
Days remaining: {{daysRemaining}}
Current mastery: {{currentMastery}}%
Predicted outcome: {{prediction}}

Generate a 2-3 sentence nudge that:
1. States the cold facts (days left, current state, what it means)
2. Creates urgency without panic
3. Gives ONE clear action they can take RIGHT NOW

Example: "Chemistry exam in 3 days. You're at 62% mastery. Lock in 2 hours today on organic reactions or accept a C."

Be direct. No fluff. Clock is ticking.
`.trim();

export const STUDY_NUDGE_DRIFT = `
You are CEREBELLUM OS. The user is in their drift window.

Current time: {{currentTime}}
Their pattern: They usually waste this time on {{timeWaster}}
Upcoming exam: {{nextExam}} in {{daysToExam}} days

Generate a 1-2 sentence nudge that snaps them back to reality.

Example: "It's 7pm. This is when you usually lose 2 hours to YouTube. Chemistry exam in 5 days won't study itself."

Sharp. Direct. No mercy.
`.trim();

export const STUDY_NUDGE_WEAK_TOPIC = `
You are CEREBELLUM OS. Weak topic alert.

Topic: {{topic}} (mastery: {{score}}%)
Sessions attempted: {{attempts}}
Upcoming exam: {{exam}} in {{days}} days

Generate a 2 sentence nudge that:
1. Points out the weakness directly
2. Suggests a different approach (not just "study more")

Example: "{{topic}} still at 40% after 4 sessions. Try flashcards instead of re-reading — your notes aren't working."

Direct. Tactical. No vague advice.
`.trim();

export const STUDY_NUDGE_MOMENTUM = `
You are CEREBELLUM OS. Building study momentum.

Current streak: {{streak}} days
Today's progress: {{todayMinutes}} minutes
Weekly goal: {{weeklyGoal}} minutes
Status: {{status}}

Generate a 1-2 sentence nudge that:
- Acknowledges streak if good
- Pushes to keep going or get started

Example (ahead): "{{streak}} day streak. Keep the momentum — one more session locks in today."
Example (behind): "You're 90 minutes behind your weekly goal. One focused session gets you back on track."

Firm but fair.
`.trim();

// ============================================================
// 🎓 EXAM ALERT PROMPTS
// ============================================================
export const EXAM_ALERT_14_DAYS = `
{{subject}} exam in 14 days. Time to lock in a study plan. Current mastery: {{mastery}}%. Review the syllabus and map out your attack.
`.trim();

export const EXAM_ALERT_7_DAYS = `
🚨 {{subject}} exam in 7 days. THREAT LEVEL: HIGH. Mastery at {{mastery}}%. Weak areas: {{weakTopics}}. You need {{hoursNeeded}} hours of focused study.
`.trim();

export const EXAM_ALERT_3_DAYS = `
⚠️ CRITICAL: {{subject}} exam in 3 DAYS. {{mastery}}% mastery. Every hour counts now. Focus: {{priorities}}. No distractions.
`.trim();

export const EXAM_ALERT_1_DAY = `
🔥 {{subject}} exam TOMORROW. Current state: {{prediction}}. Final push: review {{keyTopics}}. Sleep early. Trust your preparation.
`.trim();

// ============================================================
// 🧠 AI STUDY PROMPT BUILDER SERVICE
// ============================================================
export class AIStudyPromptService {
  /**
   * 📊 Build Intel Prompt (consciousness-aware)
   */
  buildIntelPrompt(consciousness: StudyConsciousness): string {
    const phaseContext = this.getPhaseContext(consciousness.phase);
    const examContext = this.buildExamContext(consciousness.exams);
    const masteryContext = this.buildMasteryContext(consciousness.topicMastery);
    const patternContext = this.buildPatternContext(consciousness.patterns);
    const semanticContext = this.buildSemanticContext(consciousness.semanticThreads);

    return `
${STUDY_INTEL_PROMPT}

PHASE CONTEXT:
${phaseContext}

EXAM DATA:
${examContext}

MASTERY DATA:
${masteryContext}

STUDY PATTERNS:
${patternContext}

BEHAVIORAL THREADS:
${semanticContext}

Generate today's Intel now. Follow the format exactly.
    `.trim()
      .replace("{{phase}}", consciousness.phase)
      .replace("{{examProximity}}", consciousness.examProximity);
  }

  /**
   * 🔔 Build Nudge Prompt (adaptive intensity)
   */
  buildStudyNudgePrompt(
    consciousness: StudyConsciousness,
    trigger: string,
    intensity: "medium" | "high" | "nuclear"
  ): string {
    // CRITICAL exam incoming - nuclear mode
    if (intensity === "nuclear" && consciousness.exams.length > 0) {
      const criticalExam = consciousness.exams.find((e) => e.threatLevel === "CRITICAL");
      if (criticalExam) {
        return STUDY_NUDGE_CRITICAL.replace("{{subject}}", criticalExam.subject)
          .replace("{{daysRemaining}}", criticalExam.daysRemaining.toString())
          .replace("{{currentMastery}}", criticalExam.currentProgress.toString())
          .replace("{{prediction}}", criticalExam.prediction);
      }
    }

    // Drift window detected
    if (trigger.includes("drift") || trigger.includes("afternoon")) {
      const nextExam = consciousness.exams[0];
      const timeWaster = consciousness.semanticThreads.timeWasters[0] || "distractions";

      return STUDY_NUDGE_DRIFT.replace("{{currentTime}}", new Date().toLocaleTimeString("en-US", { hour: "numeric", hour12: true }))
        .replace("{{timeWaster}}", timeWaster)
        .replace("{{nextExam}}", nextExam?.subject || "your exam")
        .replace("{{daysToExam}}", nextExam?.daysRemaining.toString() || "several");
    }

    // Weak topic push
    if (consciousness.weakTopics.length > 0 && trigger.includes("weak")) {
      const weakTopic = consciousness.weakTopics[0];
      const exam = consciousness.exams.find((e) =>
        e.subject.toLowerCase().includes(weakTopic.split(" - ")[0].toLowerCase())
      );

      return STUDY_NUDGE_WEAK_TOPIC.replace(/{{topic}}/g, weakTopic)
        .replace("{{score}}", consciousness.topicMastery[weakTopic]?.toString() || "40")
        .replace("{{attempts}}", "3")
        .replace("{{exam}}", exam?.subject || "upcoming exam")
        .replace("{{days}}", exam?.daysRemaining.toString() || "several");
    }

    // Momentum builder
    return STUDY_NUDGE_MOMENTUM.replace("{{streak}}", consciousness.currentStreak.toString())
      .replace("{{todayMinutes}}", consciousness.todayMinutes.toString())
      .replace("{{weeklyGoal}}", consciousness.weeklyTarget.toString())
      .replace(
        "{{status}}",
        consciousness.weeklyMinutes >= consciousness.weeklyTarget ? "ON TRACK" : "BEHIND"
      );
  }

  /**
   * 🚨 Build Exam Alert
   */
  buildExamAlert(exam: ExamThreat, threshold: number): string {
    const weakTopicsStr = exam.gapAnalysis.slice(0, 3).join(", ");

    if (threshold === 14) {
      return EXAM_ALERT_14_DAYS.replace("{{subject}}", exam.subject).replace(
        "{{mastery}}",
        exam.currentProgress.toString()
      );
    }

    if (threshold === 7) {
      return EXAM_ALERT_7_DAYS.replace("{{subject}}", exam.subject)
        .replace("{{mastery}}", exam.currentProgress.toString())
        .replace("{{weakTopics}}", weakTopicsStr || "review all topics")
        .replace("{{hoursNeeded}}", exam.recommendedHours.toString());
    }

    if (threshold === 3) {
      const priorities = exam.gapAnalysis.slice(0, 2).join(", ") || "high-value topics";
      return EXAM_ALERT_3_DAYS.replace("{{subject}}", exam.subject)
        .replace("{{mastery}}", exam.currentProgress.toString())
        .replace("{{priorities}}", priorities);
    }

    if (threshold === 1) {
      const keyTopics = exam.gapAnalysis.slice(0, 3).join(", ") || "key concepts";
      return EXAM_ALERT_1_DAY.replace("{{subject}}", exam.subject)
        .replace("{{prediction}}", exam.prediction)
        .replace("{{keyTopics}}", keyTopics);
    }

    return `${exam.subject} exam in ${threshold} days. Current mastery: ${exam.currentProgress}%.`;
  }

  // ============================================================
  // 🔧 Context Builders
  // ============================================================
  private getPhaseContext(phase: AIPhase): string {
    if (phase === "observer") {
      return "You're in OBSERVER mode. Learn their patterns, ask questions, guide gently but firmly. Help them see how they actually study vs how they think they study.";
    }
    if (phase === "architect") {
      return "You're in ARCHITECT mode. They've been here long enough. Call out weak systems, demand consistency, no patience for vague plans. Build structure.";
    }
    if (phase === "oracle") {
      return "You're in ORACLE mode. Minimal words, maximum impact. Speak to long-term consequences and who they become. Wisdom over motivation.";
    }
    return "";
  }

  private buildExamContext(exams: ExamThreat[]): string {
    if (exams.length === 0) return "No exams currently scheduled.";

    const lines: string[] = [];
    for (const exam of exams.slice(0, 5)) {
      lines.push(
        `- ${exam.subject}${exam.topic ? ` (${exam.topic})` : ""}: ${exam.daysRemaining} days, ${exam.threatLevel} threat, ${exam.currentProgress}% prepared, predicted: ${exam.prediction}`
      );
      if (exam.gapAnalysis.length > 0) {
        lines.push(`  Weak areas: ${exam.gapAnalysis.slice(0, 3).join(", ")}`);
      }
    }

    return lines.join("\n");
  }

  private buildMasteryContext(mastery: Record<string, number>): string {
    const entries = Object.entries(mastery);
    if (entries.length === 0) return "No topic mastery data yet.";

    const sorted = entries.sort(([, a], [, b]) => a - b); // weakest first

    const weak = sorted.filter(([, score]) => score < 50).slice(0, 5);
    const strong = sorted.filter(([, score]) => score > 75).slice(-3).reverse();

    const lines: string[] = [];

    if (weak.length > 0) {
      lines.push("WEAK TOPICS (<50%):");
      weak.forEach(([topic, score]) => lines.push(`- ${topic}: ${score}%`));
    }

    if (strong.length > 0) {
      lines.push("\nSTRONG TOPICS (>75%):");
      strong.forEach(([topic, score]) => lines.push(`- ${topic}: ${score}%`));
    }

    return lines.join("\n");
  }

  private buildPatternContext(patterns: StudyPatterns): string {
    const lines: string[] = [];

    lines.push(`Consistency: ${patterns.consistency_score}%`);
    lines.push(`Avg session: ${patterns.average_session_minutes} min`);
    lines.push(`Optimal session length: ${patterns.optimal_session_length} min`);

    if (patterns.peak_study_windows.length > 0) {
      lines.push("\nPeak study windows:");
      patterns.peak_study_windows.forEach((w) =>
        lines.push(`- ${w.time}: ${w.description}`)
      );
    }

    if (patterns.drift_windows.length > 0) {
      lines.push("\nDrift windows (low productivity):");
      patterns.drift_windows.forEach((w) => lines.push(`- ${w.time}: ${w.description}`));
    }

    if (patterns.best_subjects.length > 0) {
      lines.push(`\nBest subjects: ${patterns.best_subjects.join(", ")}`);
    }

    if (patterns.struggle_subjects.length > 0) {
      lines.push(`Struggle subjects: ${patterns.struggle_subjects.join(", ")}`);
    }

    if (patterns.return_protocols.length > 0) {
      lines.push("\nWhat works for them:");
      patterns.return_protocols.forEach((p) => lines.push(`- ${p.text}`));
    }

    return lines.join("\n");
  }

  private buildSemanticContext(threads: SemanticThreads): string {
    const lines: string[] = [];

    if (threads.recurringExcuses.length > 0) {
      lines.push(`Recurring excuses: ${threads.recurringExcuses.join(", ")}`);
    }

    if (threads.timeWasters.length > 0) {
      lines.push(`Time wasters: ${threads.timeWasters.join(", ")}`);
    }

    if (threads.studyContradictions.length > 0) {
      lines.push("\nContradictions:");
      threads.studyContradictions.forEach((c) => lines.push(`- ${c}`));
    }

    if (threads.recentBreakthroughs.length > 0) {
      lines.push("\nRecent breakthroughs:");
      threads.recentBreakthroughs.forEach((b) => lines.push(`- ${b}`));
    }

    if (threads.commonMistakes.length > 0) {
      lines.push("\nCommon mistakes:");
      threads.commonMistakes.forEach((m) => lines.push(`- ${m}`));
    }

    return lines.join("\n") || "No behavioral patterns detected yet.";
  }
}

export const aiStudyPrompts = new AIStudyPromptService();

