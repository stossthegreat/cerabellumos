# 🧠 CEREBELLUM STUDY AI OS - MASTER TRANSFORMATION PLAN

## 🎯 Mission
Transform Future-You OS backend → World's most powerful AI Study OS

**KEEP THE BEAST. REDIRECT THE POWER.**

---

## ⚡ CORE PRINCIPLE: NO DILUTION

### What We KEEP (The Power):

✅ **3-Phase AI Engine** (Observer → Architect → Oracle)  
✅ **Memory Intelligence Service** (pattern extraction, consciousness building)  lving u got shit memory

✅ **Semantic Memory** (Chroma embeddings, similarity search)  
✅ **Short-term Memory** (dialogue tracking)  
✅ **Redis + BullMQ Scheduler** (automatic firing)  
✅ **Event-driven architecture**  
✅ **Behavioral contradiction detection**  
✅ **Drift window analysis**  
✅ **Consistency scoring**  
✅ **Voice intensity calibration**  
✅ **Push notifications via Firebase**  
✅ **Pattern extraction from behavior**  
✅ **Semantic threads** (recurring excuses, time wasters, contradictions)  
✅ **Return protocols** (what works to get back on track)  

### What We TRANSFORM:

| From (Life OS) | To (Study OS) |
|----------------|---------------|
| Events: `habit_tick` | `study_session_complete` |
| Consciousness: life patterns | study patterns |
| Briefs: morning motivation | daily Intel |
| Nudges: habit reminders | exam pressure + study push |
| Memory categories: habits | topics, exams, sessions |
| AI prompts: life coach | study dominator |

### What We ADD:

✨ **Scanner pipeline** (OCR → AI solve → memory)  
✨ **Video summary pipeline** (transcript → concepts → memory)  
✨ **Exam threat calculation**  
✨ **Topic mastery tracking**  
✨ **Study session analysis**  
✨ **Intel generation** (fires into Flutter Home + Intel tabs)  
✨ **Mastery-based predictions**  
✨ **Adaptive intensity** (increases as exams approach)  

---

## 📋 PHASE 1: DATABASE SCHEMA TRANSFORMATION

**File:** `backend/prisma/schema.prisma`

### ❌ REMOVE These Models (Not needed for study OS):

```prisma
// DELETE THESE:
model Habit
model AntiHabit  
model Alarm
model HabitSnapshot
model Completion
model TodaySelection
model FutureYouPurposeProfile
model FutureYouChapter
model FutureYouBookEdition
model FutureYouJob
model LifeTaskChapter
model LifeTaskArtifact
model LifeTaskBook
```

### ✅ KEEP These Models (Core System):

```prisma
// KEEP - Core infrastructure
model User           ✅
model Event          ✅ (backbone of everything)
model UserFacts      ✅ (stores consciousness)
model VoiceCache     ✅ (TTS optimization)
model CoachMessage   ✅ (stores Intel/nudges)
```

### ➕ ADD These Models (Study-Specific):

```prisma
// 🎓 EXAMS
model Exam {
  id            String    @id @default(cuid())
  userId        String
  subject       String
  topic         String?   // "Organic Chemistry", "Cell Division"
  date          DateTime
  weight        Int       @default(100) // % of final grade
  targetGrade   String?   // "A", "A+", "90%"
  icon          String    @default("📚")
  
  // Computed fields (updated by intelligence service)
  daysRemaining Int       @default(0)
  threatLevel   String    @default("MEDIUM") // CRITICAL, HIGH, MEDIUM, LOW
  progress      Int       @default(0)        // 0-100% prep completion
  prediction    String?   // "72%", "B+", predicted outcome
  
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt
  
  user          User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([userId, date])
  @@index([threatLevel])
}

// 📚 STUDY SESSIONS
model StudySession {
  id              String    @id @default(cuid())
  userId          String
  subject         String
  topic           String?
  minutes         Int
  effectiveness   Int?      // 1-10 self-rating (optional)
  notes           String?   @db.Text
  
  // Auto-calculated by intelligence service
  masteryDelta    Float?    // change in mastery score after session
  focusScore      Int?      // calculated from duration/effectiveness
  
  createdAt       DateTime  @default(now())
  
  user            User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([userId, createdAt])
  @@index([subject])
}

// 🎯 TOPIC MASTERY TRACKING
model TopicMastery {
  id          String    @id @default(cuid())
  userId      String
  subject     String
  topic       String
  score       Int       @default(0) // 0-100
  confidence  Int       @default(50) // how confident they feel (1-100)
  
  lastStudied DateTime?
  totalMinutes Int      @default(0)
  sessionsCount Int     @default(0)
  
  // Pattern tracking (derived from sessions)
  peakTimes   String[]  @default([]) // ["9am-11am", "2pm-4pm"]
  struggles   String[]  @default([]) // common mistakes/weak areas
  
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@unique([userId, subject, topic])
  @@index([userId])
  @@index([userId, score])
}

// 🤖 PROJECTS (Canvas/Neural Tab - Chat Sessions)
model Project {
  id          String    @id @default(cuid())
  userId      String
  name        String
  emoji       String    @default("📚")
  description String?   @db.Text
  pinned      Boolean   @default(false)
  
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  lastActive  DateTime  @default(now())
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  messages    Message[]
  
  @@index([userId])
  @@index([userId, lastActive])
}

// 💬 MESSAGES (Chat History per Project)
model Message {
  id          String    @id @default(cuid())
  projectId   String
  role        String    // "user" | "assistant"
  content     String    @db.Text
  
  createdAt   DateTime  @default(now())
  
  project     Project   @relation(fields: [projectId], references: [id], onDelete: Cascade)
  
  @@index([projectId])
  @@index([projectId, createdAt])
}

// 🔍 SCANNED PROBLEMS (OCR + AI Solve)
model ScannedProblem {
  id          String    @id @default(cuid())
  userId      String
  subject     String?
  topic       String?
  
  imageUrl    String?   // S3 URL if stored
  ocrText     String    @db.Text
  solution    String    @db.Text
  explanation String    @db.Text
  
  saved       Boolean   @default(false)
  
  createdAt   DateTime  @default(now())
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([userId, createdAt])
}

// 🎥 VIDEO SUMMARIES
model VideoSummary {
  id          String    @id @default(cuid())
  userId      String
  title       String
  url         String?
  subject     String?
  topic       String?
  
  transcript  String?   @db.Text
  summary     String    @db.Text
  keyPoints   String[]  @default([])
  
  saved       Boolean   @default(false)
  
  createdAt   DateTime  @default(now())
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([userId, createdAt])
}

// 🎯 STUDY TARGETS (User-created from Flutter FAB)
model StudyTarget {
  id          String    @id @default(cuid())
  userId      String
  title       String
  description String?   @db.Text
  emoji       String    @default("🎯")
  
  startDate   DateTime
  endDate     DateTime
  
  completed   Boolean   @default(false)
  completedAt DateTime?
  
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([userId, completed])
}
```

### 🔄 UPDATE User Model:

```prisma
model User {
  id           String  @id @default(cuid())
  email        String? @unique
  tz           String  @default("Europe/London")
  tone         Tone    @default(balanced)
  intensity    Int     @default(2)
  consentRoast Boolean @default(false)
  safeWord     String?
  plan         Plan    @default(FREE)
  
  // Study OS specific
  mentorId        String?  // AI personality (marcus, drill, etc)
  fcmToken        String?  // Push notifications
  nudgesEnabled   Boolean  @default(true)
  intelEnabled    Boolean  @default(true) // Daily Intel
  studyReminders  Boolean  @default(true)
  
  // Study preferences
  grade           String?  // "Year 11", "Sophomore"
  studyGoals      String[] @default([])
  learningStyle   String?  // "visual", "auditory", "kinesthetic"
  
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  events          Event[]
  userFacts       UserFacts?
  exams           Exam[]
  studySessions   StudySession[]
  topicMastery    TopicMastery[]
  projects        Project[]
  scannedProblems ScannedProblem[]
  videoSummaries  VideoSummary[]
  studyTargets    StudyTarget[]
}
```

### 📝 Migration Strategy:

1. Create new migration: `20241122_study_os_transformation.sql`
2. Keep `Event` model intact (backward compatible)
3. Old events still work for pattern analysis
4. New events use study types: `study_session_complete`, `exam_created`, `topic_mastered`, etc.

---

## 📋 PHASE 2: MEMORY INTELLIGENCE TRANSFORMATION

**File:** `backend/src/services/study-intelligence.service.ts` (NEW - based on memory-intelligence.service.ts)

### Core Structure (Adapted from existing):

```typescript
export interface StudyPatterns {
  peak_study_windows: TimeWindow[];      // when they study best
  drift_windows: TimeWindow[];           // when they procrastinate  
  consistency_score: number;             // % of planned sessions completed
  procrastination_triggers: string[];    // "YouTube", "TikTok", "gaming"
  return_protocols: Protocol[];          // what gets them back on track
  average_session_minutes: number;
  best_subjects: string[];               // high mastery
  struggle_subjects: string[];           // low mastery
  optimal_session_length: number;        // sweet spot duration
  last_analyzed: Date;
}

export interface ExamThreat {
  examId: string;
  subject: string;
  topic: string | null;
  daysRemaining: number;
  threatLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW";
  currentProgress: number;  // 0-100%
  prediction: string;       // "72%", "B+"
  gapAnalysis: string[];    // weak topics for this exam
  recommendedHours: number; // hours needed to hit target
}

export interface StudyConsciousness {
  identity: {
    name: string;
    grade: string | null;
    studyGoals: string[];
    learningStyle: string | null;
    createdAt: Date;
  };
  
  // KEEP THIS POWERFUL PATTERN DETECTION
  patterns: StudyPatterns;
  
  // Exam context
  exams: ExamThreat[];
  examProximity: "CRITICAL" | "HIGH" | "MEDIUM" | "NONE"; // closest exam threat
  
  // Topic mastery
  topicMastery: Record<string, number>; // "Organic Chem": 45
  weakTopics: string[];    // < 50% mastery
  strongTopics: string[];  // > 75% mastery
  stuckTopics: string[];   // studied multiple times, no improvement
  
  // Recent activity
  recentSessions: any[];
  todayMinutes: number;
  weeklyMinutes: number;
  weeklyTarget: number;
  
  // Semantic threads (KEEP THIS POWER)
  semanticThreads: {
    recurringExcuses: string[];        // "didn't understand", "too hard"
    timeWasters: string[];             // "scrolling", "gaming"
    studyContradictions: string[];     // "wants A+ but studies 30min"
    recentBreakthroughs: string[];     // moments of clarity
    commonMistakes: string[];          // recurring errors
  };
  
  // AI phase (KEEP THIS)
  phase: AIPhase; // observer | architect | oracle
  os_phase: OSPhase;
  tone: string;
  nextEvolution: string;
  
  // Study-specific
  currentStreak: number;
  longestStreak: number;
  totalStudyHours: number;
}

export class StudyIntelligenceService {
  /**
   * 🧠 Build Study Consciousness (ADAPTED from buildUserConsciousness)
   * Same pattern extraction logic, different data sources
   */
  async buildStudyConsciousness(userId: string): Promise<StudyConsciousness> {
    const [user, facts, exams, sessions, mastery] = await Promise.all([
      prisma.user.findUnique({ where: { id: userId } }),
      prisma.userFacts.findUnique({ where: { userId } }),
      prisma.exam.findMany({ where: { userId }, orderBy: { date: 'asc' } }),
      this.getRecentSessions(userId, 30), // last 30 days
      prisma.topicMastery.findMany({ where: { userId } }),
    ]);
    
    const factsData = (facts?.json as any) || {};
    const identity = await this.getStudyIdentity(userId, user);
    
    // REUSE existing phase determination logic
    const phase = this.determinePhase(factsData, identity, user?.createdAt || new Date());
    const os_phase = this.getOrInitializePhase(factsData, user?.createdAt || new Date());
    
    // REUSE pattern extraction (adapted for study)
    const patterns = await this.extractStudyPatterns(userId, sessions);
    
    // Build exam threats
    const examThreats = this.calculateExamThreats(exams, mastery);
    const examProximity = this.getExamProximity(examThreats);
    
    // Build mastery maps
    const topicMasteryMap = this.buildMasteryMap(mastery);
    const weakTopics = mastery.filter(m => m.score < 50).map(m => m.topic);
    const strongTopics = mastery.filter(m => m.score > 75).map(m => m.topic);
    const stuckTopics = this.findStuckTopics(mastery, sessions);
    
    // REUSE semantic threads extraction (same logic, study events)
    const semanticThreads = await this.buildStudySemanticThreads(userId);
    
    // Calculate streaks and totals
    const streakData = this.calculateStudyStreaks(sessions);
    
    return {
      identity,
      patterns,
      exams: examThreats,
      examProximity,
      topicMastery: topicMasteryMap,
      weakTopics,
      strongTopics,
      stuckTopics,
      recentSessions: sessions.slice(0, 10),
      todayMinutes: this.getTodayMinutes(sessions),
      weeklyMinutes: this.getWeeklyMinutes(sessions),
      weeklyTarget: user?.weeklyGoal || 600, // 10 hours default
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
  
  /**
   * 🔥 Extract Study Patterns (ADAPTED from extractPatternsFromEvents)
   * KEEP all the pattern detection logic, just change what we're analyzing
   */
  async extractStudyPatterns(userId: string, sessions: any[]): Promise<StudyPatterns> {
    // Find peak study windows (when mastery improves most)
    const peak_study_windows = this.findPeakStudyWindows(sessions);
    
    // Find drift windows (times they planned but didn't study)
    const drift_windows = this.findDriftWindows(sessions);
    
    // Calculate consistency (planned sessions vs completed)
    const consistency_score = this.calculateConsistency(userId, sessions);
    
    // Detect procrastination triggers from events + semantic memory
    const procrastination_triggers = await this.detectProcrastinationTriggers(userId);
    
    // Extract what helps them return to studying
    const return_protocols = await this.extractReturnProtocols(userId);
    
    // Analyze session durations
    const avg_minutes = sessions.length > 0 
      ? sessions.reduce((sum, s) => sum + s.minutes, 0) / sessions.length 
      : 0;
    
    // Best/worst subjects by mastery improvement
    const subjectPerformance = this.analyzeSubjectPerformance(sessions);
    
    return {
      peak_study_windows,
      drift_windows,
      consistency_score,
      procrastination_triggers,
      return_protocols,
      average_session_minutes: Math.round(avg_minutes),
      best_subjects: subjectPerformance.best,
      struggle_subjects: subjectPerformance.struggles,
      optimal_session_length: this.findOptimalSessionLength(sessions),
      last_analyzed: new Date(),
    };
  }
  
  /**
   * 🧵 Build Study Semantic Threads (REUSE semantic memory logic)
   */
  private async buildStudySemanticThreads(userId: string): Promise<SemanticThreads> {
    // Query semantic memory for study-related events
    const memories = await semanticMemory.getRecentMemories({
      userId,
      limit: 30,
    });
    
    // REUSE existing pattern detection (same algorithm)
    const recurringExcuses = this.extractRecurringPhrases(
      memories.map(m => m.text),
      ["didn't understand", "too hard", "confused", "not enough time", "will do later"]
    );
    
    const timeWasters = this.extractRecurringPhrases(
      memories.map(m => m.text),
      ["scroll", "youtube", "tiktok", "instagram", "gaming", "netflix", "distracted"]
    );
    
    const studyContradictions = this.detectContradictoryPatterns(memories);
    
    const breakthroughs = this.extractBreakthroughs(memories);
    
    const commonMistakes = this.extractCommonMistakes(memories);
    
    return {
      recurringExcuses,
      timeWasters,
      studyContradictions,
      recentBreakthroughs: breakthroughs,
      commonMistakes,
    };
  }
  
  /**
   * 🎯 Calculate Exam Threats
   */
  private calculateExamThreats(exams: any[], mastery: any[]): ExamThreat[] {
    return exams.map(exam => {
      const daysRemaining = Math.ceil(
        (new Date(exam.date).getTime() - Date.now()) / (1000 * 60 * 60 * 24)
      );
      
      // Find relevant topic mastery scores
      const relevantTopics = mastery.filter(m => 
        m.subject === exam.subject && (exam.topic ? m.topic === exam.topic : true)
      );
      
      const avgMastery = relevantTopics.length > 0
        ? relevantTopics.reduce((sum, t) => sum + t.score, 0) / relevantTopics.length
        : 0;
      
      // Calculate progress (based on mastery + time remaining)
      const progress = Math.min(100, Math.round(avgMastery * 0.7 + (daysRemaining > 0 ? 30 : 0)));
      
      // Predict outcome
      const prediction = this.predictExamOutcome(avgMastery, daysRemaining, exam.weight);
      
      // Threat level
      let threatLevel: "CRITICAL" | "HIGH" | "MEDIUM" | "LOW";
      if (daysRemaining <= 5 && avgMastery < 60) threatLevel = "CRITICAL";
      else if (daysRemaining <= 7 || avgMastery < 50) threatLevel = "HIGH";
      else if (daysRemaining <= 14 || avgMastery < 70) threatLevel = "MEDIUM";
      else threatLevel = "LOW";
      
      // Gap analysis (weak topics for this exam)
      const gapAnalysis = relevantTopics
        .filter(t => t.score < 60)
        .map(t => `${t.topic} (${t.score}%)`);
      
      // Hours needed
      const hoursNeeded = this.calculateRequiredHours(avgMastery, 80, daysRemaining);
      
      return {
        examId: exam.id,
        subject: exam.subject,
        topic: exam.topic,
        daysRemaining,
        threatLevel,
        currentProgress: progress,
        prediction,
        gapAnalysis,
        recommendedHours: hoursNeeded,
      };
    });
  }
}
```

**Key Adaptation:**
- ✅ Keep ALL pattern detection algorithms
- ✅ Keep semantic thread extraction
- ✅ Keep contradiction detection
- ✅ Keep phase determination logic
- 🔄 Change: analyze `study_session_complete` events instead of `habit_tick`
- 🔄 Change: extract study patterns instead of habit patterns
- ➕ Add: exam threat calculation
- ➕ Add: mastery tracking

---

## 📋 PHASE 3: AI SERVICE TRANSFORMATION

**File:** `backend/src/services/ai.service.ts` (UPDATE existing)

### ➕ ADD New Methods (Keep existing chat method):

```typescript
/**
 * 📊 Generate Daily Intel (REPLACES generateMorningBrief)
 * Fires at 7am via scheduler → displays in Home + Intel tabs
 */
async generateDailyIntel(userId: string): Promise<{
  threatAssessment: string;
  weaknesses: string[];
  predictions: string[];
  todaysMissions: Array<{task: string; priority: string; time: string}>;
  insights: string[];
  fullText: string;
}> {
  const consciousness = await studyIntelligence.buildStudyConsciousness(userId);
  
  const prompt = aiPromptService.buildIntelPrompt(consciousness);
  
  const fullText = await this.generateWithConsciousnessPrompt(
    userId,
    prompt,
    { purpose: "intel", maxChars: 2000 }
  );
  
  // Parse structured output from AI
  return this.parseIntelOutput(fullText);
}

/**
 * 🔔 Generate Study Nudge (TRANSFORM existing generateNudge)
 * INTENSITY INCREASES AS EXAMS APPROACH
 */
async generateStudyNudge(userId: string, trigger: string): Promise<string> {
  const consciousness = await studyIntelligence.buildStudyConsciousness(userId);
  
  // Adaptive intensity based on exam proximity
  let intensity = "medium";
  if (consciousness.examProximity === "CRITICAL") intensity = "nuclear";
  else if (consciousness.examProximity === "HIGH") intensity = "high";
  
  const prompt = aiPromptService.buildStudyNudgePrompt(
    consciousness, 
    trigger, 
    intensity
  );
  
  return this.generateWithConsciousnessPrompt(
    userId,
    prompt,
    { purpose: "nudge", maxChars: 300 }
  );
}

/**
 * 🔍 Solve Scanned Problem (NEW)
 */
async solveProblem(
  userId: string, 
  ocrText: string, 
  subject?: string
): Promise<{
  solution: string;
  explanation: string;
  topic: string;
  steps: string[];
}> {
  const openai = getOpenAIClient();
  if (!openai) throw new Error("AI not available");
  
  const completion = await openai.chat.completions.create({
    model: OPENAI_MODEL,
    max_completion_tokens: 3000,
    messages: [
      {
        role: "system",
        content: `You are an elite study AI. Solve this problem with crystal clarity.
        
        Output format:
        SOLUTION: [final answer]
        
        EXPLANATION:
        [step-by-step explanation]
        
        TOPIC: [specific topic, e.g., "Organic Chemistry - Reactions"]
        
        STEPS:
        1. [first step]
        2. [second step]
        ...
        `
      },
      {
        role: "user",
        content: `Problem:\n${ocrText}\n\nSubject: ${subject || "Unknown"}`
      }
    ]
  });
  
  const text = completion.choices[0]?.message?.content || "";
  const parsed = this.parseSolutionOutput(text);
  
  // Store in semantic memory
  await semanticMemory.storeMemory({
    userId,
    type: "scan_solve" as any,
    text: `Problem: ${ocrText}\nSolution: ${parsed.solution}`,
    metadata: { subject, topic: parsed.topic },
    importance: 4,
  });
  
  // Update topic mastery
  if (parsed.topic) {
    await this.updateTopicMastery(userId, subject || "General", parsed.topic, 5);
  }
  
  return parsed;
}

/**
 * 🎥 Summarize Video Content (NEW)
 */
async summarizeVideo(
  userId: string, 
  transcript: string, 
  title: string
): Promise<{
  summary: string;
  keyPoints: string[];
  subject?: string;
  topic?: string;
  concepts: string[];
}> {
  const openai = getOpenAIClient();
  if (!openai) throw new Error("AI not available");
  
  const completion = await openai.chat.completions.create({
    model: OPENAI_MODEL,
    max_completion_tokens: 2000,
    messages: [
      {
        role: "system",
        content: `Analyze this educational video and extract key learning points.
        
        Output format:
        SUBJECT: [subject area]
        TOPIC: [specific topic]
        
        SUMMARY:
        [2-3 paragraph summary]
        
        KEY POINTS:
        - [point 1]
        - [point 2]
        - [point 3]
        
        CONCEPTS:
        - [concept 1]
        - [concept 2]
        `
      },
      {
        role: "user",
        content: `Title: ${title}\n\nTranscript:\n${transcript.slice(0, 8000)}`
      }
    ]
  });
  
  const text = completion.choices[0]?.message?.content || "";
  const parsed = this.parseVideoSummary(text);
  
  // Store in semantic memory
  await semanticMemory.storeMemory({
    userId,
    type: "video_summary" as any,
    text: `Video: ${title}\nSummary: ${parsed.summary}`,
    metadata: { subject: parsed.subject, topic: parsed.topic },
    importance: 3,
  });
  
  return parsed;
}
```

### 🔄 KEEP These Methods (Core AI):

- ✅ `generateWithConsciousnessPrompt()` - main AI engine
- ✅ `buildMemoryContext()` - consciousness context builder
- ✅ `buildVoiceForPhase()` - phase-aware voice calibration
- ✅ All the retry logic and error handling

---

## 📋 PHASE 4: AI PROMPTS TRANSFORMATION

**File:** `backend/src/services/ai-study-prompts.service.ts` (NEW - replaces ai-os-prompts.service.ts)

### 📊 DAILY INTEL PROMPT:

```typescript
export const STUDY_INTEL_PROMPT = `
You are CEREBELLUM OS — the user's hyper-intelligent study AI.

You have complete visibility into:
- Their exam schedule and threat levels
- Their topic mastery scores (what they know vs what they don't)
- Their study patterns (when they work best, when they drift)
- Their procrastination triggers and recurring excuses
- Their consistency score and study streaks

Your job: Generate DAILY INTEL that will display in their app.

FORMAT (STRICT):

🚨 THREAT ASSESSMENT (2-3 sentences)
- List upcoming exams with days remaining
- Highlight CRITICAL threats (< 7 days OR low mastery)
- Be direct about what's at stake

⚡ WEAK POINTS (bullet list, 2-4 items)
- Topics with < 50% mastery that are exam-relevant
- Subjects they keep avoiding
- Concepts they've studied multiple times but still struggle with

📈 PREDICTIONS (2-3 sentences)
- Based on current mastery + time remaining, predict exam outcomes
- Be honest: "At this rate you're heading for a C"
- Show what's possible: "Push to 4h/day and you can hit A-"

🎯 TODAY'S MISSIONS (list of 3-4 tasks, each < 15 words)
- Prioritize by: exam proximity, mastery gaps, consistency
- Format: "[Time] [Subject] - [Specific Topic] ([Duration])"
- Example: "09:00 Chemistry - Organic Reactions (45 min)"

💡 INSIGHTS (1-2 sentences)
- Call out patterns: "You study best 9-11am but keep wasting it"
- Expose contradictions: "You say chemistry is priority but studied bio 3x more"
- Highlight wins: "Math mastery jumped 15% this week — replicate that approach"

STYLE RULES:
- Short, hard sentences
- Use their ACTUAL data (exam names, mastery scores, time windows)
- No motivational fluff
- No metaphors or poetry
- Direct, tactical, urgent
- Scale intensity based on exam proximity

PHASE ADAPTATION:
- OBSERVER: More questions, help them see their patterns
- ARCHITECT: High directness, call out systems that aren't working
- ORACLE: Few words, maximum weight, legacy-level pressure

Current phase: {{phase}}
Exam proximity: {{examProximity}}
`.trim();

export const STUDY_NUDGE_PROMPT_CRITICAL = `
You are CEREBELLUM OS. The user has a CRITICAL exam threat.

Days until exam: {{daysRemaining}}
Current mastery: {{currentMastery}}%
Predicted outcome: {{prediction}}

Generate a 2-3 sentence nudge that:
1. States the facts (days left, current state)
2. Creates urgency without panic
3. Gives ONE clear action

Example: "Chemistry exam in 3 days. You're at 62% mastery. Lock in 2 hours today on organic reactions or accept a C."

Be direct. No fluff. Clock is ticking.
`.trim();

export const STUDY_NUDGE_PROMPT_DRIFT = `
You are CEREBELLUM OS. The user is in a drift window.

Current time: {{currentTime}}
Pattern: They usually slack off at this time
Recent activity: {{recentActivity}}

Generate a 1-2 sentence nudge that calls them back to studying.

Example: "It's 7pm. This is when you usually lose 2 hours to YouTube. Chemistry won't study itself."

Sharp. Direct. No softness.
`.trim();
```

### 🎭 PHASE-BASED VOICE CALIBRATION:

```typescript
export class AIStudyPromptService {
  /**
   * Build Intel Prompt (consciousness-aware)
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

Generate today's Intel now.
    `.trim();
  }
  
  /**
   * Build Nudge Prompt (adaptive intensity)
   */
  buildStudyNudgePrompt(
    consciousness: StudyConsciousness,
    trigger: string,
    intensity: "medium" | "high" | "nuclear"
  ): string {
    if (intensity === "nuclear" && consciousness.exams.length > 0) {
      const criticalExam = consciousness.exams.find(e => e.threatLevel === "CRITICAL");
      if (criticalExam) {
        return STUDY_NUDGE_PROMPT_CRITICAL
          .replace("{{daysRemaining}}", criticalExam.daysRemaining.toString())
          .replace("{{currentMastery}}", criticalExam.currentProgress.toString())
          .replace("{{prediction}}", criticalExam.prediction);
      }
    }
    
    if (trigger === "drift_window") {
      return STUDY_NUDGE_PROMPT_DRIFT
        .replace("{{currentTime}}", new Date().toLocaleTimeString())
        .replace("{{recentActivity}}", this.getRecentActivity(consciousness));
    }
    
    // Default study nudge
    return this.buildDefaultStudyNudge(consciousness, trigger);
  }
}
```

---

## 📋 PHASE 5: SCHEDULER TRANSFORMATION

**File:** `backend/src/jobs/scheduler.ts` (UPDATE existing)

### 🔄 Transform Existing Jobs:

```typescript
// BEFORE: ensureDailyBriefJobs() → fires generateMorningBrief()
// AFTER:  ensureDailyIntelJobs() → fires generateDailyIntel()

async function ensureDailyIntelJobs() {
  const users = await prisma.user.findMany({ 
    where: { intelEnabled: true },
    select: { id: true, tz: true } 
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
  return { ok: true, users: users.length };
}

async function runDailyIntel(userId: string) {
  const intel = await aiService.generateDailyIntel(userId);
  
  // Store as CoachMessage (kind = "intel")
  await coachMessageService.createMessage(
    userId, 
    "intel" as any, // Add to CoachMessageKind enum
    intel.fullText, 
    { 
      threatAssessment: intel.threatAssessment,
      missions: intel.todaysMissions,
      predictions: intel.predictions,
    }
  );
  
  // Event for memory
  await prisma.event.create({
    data: { 
      userId, 
      type: "daily_intel", 
      payload: intel 
    },
  });
  
  // Push notification
  await notificationsService.send(
    userId, 
    "📊 Daily Intel", 
    intel.threatAssessment.slice(0, 180)
  );
  
  return { ok: true };
}

// TRANSFORM: Nudges become exam-aware
async function runStudyNudge(userId: string, trigger: string) {
  const text = await aiService.generateStudyNudge(userId, trigger);
  
  await coachMessageService.createMessage(userId, "nudge", text, { trigger });
  
  await prisma.event.create({
    data: { userId, type: "study_nudge", payload: { text, trigger } },
  });
  
  await notificationsService.send(userId, "🔥 Study Push", text);
  
  return { ok: true };
}
```

### ➕ ADD New Scheduled Jobs:

```typescript
/**
 * 🚨 Exam Countdown Alerts
 * Fires at key thresholds: 14d, 7d, 3d, 1d before each exam
 */
async function checkExamThresholds() {
  const exams = await prisma.exam.findMany({
    where: {
      date: {
        gte: new Date(),
        lte: new Date(Date.now() + 14 * 86400000), // next 14 days
      }
    },
    include: { user: true },
  });
  
  for (const exam of exams) {
    const daysRemaining = Math.ceil(
      (new Date(exam.date).getTime() - Date.now()) / 86400000
    );
    
    // Fire alerts at thresholds
    if ([14, 7, 3, 1].includes(daysRemaining)) {
      const alertText = await aiService.generateExamAlert(
        exam.userId, 
        exam.subject, 
        daysRemaining
      );
      
      await coachMessageService.createMessage(
        exam.userId,
        "nudge",
        alertText,
        { examId: exam.id, threshold: daysRemaining }
      );
      
      await notificationsService.send(
        exam.userId,
        `🚨 ${exam.subject} in ${daysRemaining} days`,
        alertText
      );
    }
  }
  
  return { ok: true, checked: exams.length };
}

/**
 * 🎯 Weak Topic Push
 * Every 48h: check for topics with low mastery + upcoming exams
 */
async function pushWeakTopics() {
  const users = await prisma.user.findMany({ 
    select: { id: true },
    where: { studyReminders: true }
  });
  
  for (const user of users) {
    const consciousness = await studyIntelligence.buildStudyConsciousness(user.id);
    
    // If they have weak topics + upcoming exams
    if (consciousness.weakTopics.length > 0 && consciousness.exams.length > 0) {
      const criticalWeakness = consciousness.weakTopics[0];
      const relatedExam = consciousness.exams.find(e => 
        e.subject.toLowerCase().includes(criticalWeakness.toLowerCase())
      );
      
      if (relatedExam && relatedExam.daysRemaining < 30) {
        const nudge = `${criticalWeakness} is still weak. ${relatedExam.subject} exam in ${relatedExam.daysRemaining} days. Attack this today.`;
        
        await coachMessageService.createMessage(user.id, "nudge", nudge, {
          trigger: "weak_topic_push",
          topic: criticalWeakness,
        });
      }
    }
  }
  
  return { ok: true };
}

/**
 * 📊 Post-Study Analysis
 * Fires after each study session is logged
 */
async function analyzeStudySession(sessionId: string) {
  const session = await prisma.studySession.findUnique({
    where: { id: sessionId },
  });
  
  if (!session) return { ok: false };
  
  // Update topic mastery
  await studyIntelligence.updateMasteryFromSession(session);
  
  // Update patterns
  await studyIntelligence.extractStudyPatterns(session.userId, [session]);
  
  // Store in semantic memory
  await semanticMemory.storeMemory({
    userId: session.userId,
    type: "study_session" as any,
    text: `Studied ${session.subject} - ${session.topic || 'general'} for ${session.minutes} minutes`,
    metadata: { 
      subject: session.subject, 
      topic: session.topic,
      minutes: session.minutes,
    },
    importance: 3,
  });
  
  return { ok: true };
}
```

### 🔧 Update Bootstrap:

```typescript
export async function bootstrapSchedulers() {
  console.log("⏰ Cerebellum OS Schedulers Active");
  
  // Daily Intel (7am)
  await schedulerQueue.add("ensure-daily-intel", {}, {
    repeat: { every: 6 * 60 * 60_000 },
    removeOnComplete: true,
  });
  
  // Evening debrief can stay or remove (your choice)
  await schedulerQueue.add("ensure-evening-debriefs", {}, {
    repeat: { every: 6 * 60 * 60_000 },
    removeOnComplete: true,
  });
  
  // Study nudges (10am, 2pm, 6pm)
  await schedulerQueue.add("ensure-study-nudges", {}, {
    repeat: { every: 6 * 60 * 60_000 },
    removeOnComplete: true,
  });
  
  // Exam threshold alerts (check hourly)
  await schedulerQueue.add("exam-thresholds", {}, {
    repeat: { every: 60 * 60_000 },
    removeOnComplete: true,
  });
  
  // Weak topic push (every 48h)
  await schedulerQueue.add("weak-topic-push", {}, {
    repeat: { every: 48 * 60 * 60_000 },
    removeOnComplete: true,
  });
  
  // Weekly consolidation (Sundays)
  await schedulerQueue.add("weekly-consolidation", {}, {
    repeat: { pattern: "0 0 * * 0" },
    removeOnComplete: true,
  });
}
```

---

## 📋 PHASE 6: API ENDPOINTS (Controllers)

### 📊 Intel Controller (NEW)

**File:** `backend/src/controllers/intel.controller.ts`

```typescript
import { FastifyInstance } from "fastify";
import { authMiddleware } from "../middleware/auth.middleware";
import { aiService } from "../services/ai.service";
import { prisma } from "../utils/db";

export async function intelController(fastify: FastifyInstance) {
  // Get latest daily Intel
  fastify.get("/intel/latest", async (req: any) => {
    const userId = req.userId;
    
    // Get most recent Intel message
    const latest = await prisma.coachMessage.findFirst({
      where: { 
        userId, 
        kind: "intel" as any 
      },
      orderBy: { createdAt: "desc" },
    });
    
    if (!latest) {
      // Generate on-demand if none exists
      const intel = await aiService.generateDailyIntel(userId);
      return intel;
    }
    
    return {
      text: latest.body,
      meta: latest.meta,
      createdAt: latest.createdAt,
    };
  });
  
  // Force regenerate Intel
  fastify.post("/intel/regenerate", async (req: any) => {
    const userId = req.userId;
    const intel = await aiService.generateDailyIntel(userId);
    return intel;
  });
  
  // Get Intel history
  fastify.get("/intel/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 7 } = req.query as any;
    
    const history = await prisma.coachMessage.findMany({
      where: { userId, kind: "intel" as any },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
    
    return { history };
  });
}
```

### 📚 Study Sessions Controller (NEW)

**File:** `backend/src/controllers/study-sessions.controller.ts`

```typescript
export async function studySessionsController(fastify: FastifyInstance) {
  // Log a study session
  fastify.post("/study/session", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, minutes, effectiveness, notes } = req.body;
    
    const session = await prisma.studySession.create({
      data: {
        userId,
        subject,
        topic,
        minutes,
        effectiveness,
        notes,
      },
    });
    
    // Trigger post-study analysis
    await schedulerQueue.add("analyze-session", { sessionId: session.id });
    
    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "study_session_complete",
        payload: { sessionId: session.id, subject, topic, minutes },
      },
    });
    
    return { ok: true, session };
  });
  
  // Get recent sessions
  fastify.get("/study/sessions", async (req: any) => {
    const userId = req.userId;
    const { limit = 20 } = req.query as any;
    
    const sessions = await prisma.studySession.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
    
    return { sessions };
  });
  
  // Get today's progress
  fastify.get("/study/today", async (req: any) => {
    const userId = req.userId;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const sessions = await prisma.studySession.findMany({
      where: {
        userId,
        createdAt: { gte: today },
      },
    });
    
    const totalMinutes = sessions.reduce((sum, s) => sum + s.minutes, 0);
    const subjects = [...new Set(sessions.map(s => s.subject))];
    
    return {
      minutes: totalMinutes,
      sessions: sessions.length,
      subjects,
      sessions: sessions,
    };
  });
}
```

### 🎯 Exams Controller (NEW)

**File:** `backend/src/controllers/exams.controller.ts`

```typescript
export async function examsController(fastify: FastifyInstance) {
  // Create exam
  fastify.post("/exams", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, date, weight, targetGrade, icon } = req.body;
    
    const exam = await prisma.exam.create({
      data: {
        userId,
        subject,
        topic,
        date: new Date(date),
        weight,
        targetGrade,
        icon,
      },
    });
    
    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "exam_created",
        payload: { examId: exam.id, subject, date },
      },
    });
    
    // Trigger threat recalculation
    await studyIntelligence.recalculateExamThreats(userId);
    
    return { ok: true, exam };
  });
  
  // Get all exams with threat levels
  fastify.get("/exams", async (req: any) => {
    const userId = req.userId;
    
    const exams = await prisma.exam.findMany({
      where: { userId },
      orderBy: { date: "asc" },
    });
    
    // Recalculate threats on fetch
    const consciousness = await studyIntelligence.buildStudyConsciousness(userId);
    const threatsMap = new Map(consciousness.exams.map(e => [e.examId, e]));
    
    const enrichedExams = exams.map(exam => ({
      ...exam,
      daysRemaining: threatsMap.get(exam.id)?.daysRemaining || 0,
      threatLevel: threatsMap.get(exam.id)?.threatLevel || "MEDIUM",
      progress: threatsMap.get(exam.id)?.currentProgress || 0,
      prediction: threatsMap.get(exam.id)?.prediction || "N/A",
    }));
    
    return { exams: enrichedExams };
  });
  
  // Delete exam
  fastify.delete("/exams/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    
    await prisma.exam.delete({
      where: { id, userId }, // security: must be their exam
    });
    
    return { ok: true };
  });
}
```

### 📐 Topic Mastery Controller (NEW)

**File:** `backend/src/controllers/mastery.controller.ts`

```typescript
export async function masteryController(fastify: FastifyInstance) {
  // Get mastery for all topics
  fastify.get("/mastery", async (req: any) => {
    const userId = req.userId;
    
    const mastery = await prisma.topicMastery.findMany({
      where: { userId },
      orderBy: { score: "asc" }, // weakest first
    });
    
    return { mastery };
  });
  
  // Update topic mastery (manual or after quiz)
  fastify.post("/mastery/update", async (req: any) => {
    const userId = req.userId;
    const { subject, topic, score, confidence } = req.body;
    
    const updated = await prisma.topicMastery.upsert({
      where: {
        userId_subject_topic: { userId, subject, topic },
      },
      update: {
        score,
        confidence,
        lastStudied: new Date(),
        updatedAt: new Date(),
      },
      create: {
        userId,
        subject,
        topic,
        score,
        confidence,
        lastStudied: new Date(),
      },
    });
    
    // Log event
    await prisma.event.create({
      data: {
        userId,
        type: "topic_mastered",
        payload: { subject, topic, score },
      },
    });
    
    return { ok: true, mastery: updated };
  });
}
```

### 🔍 Scanner Controller (NEW)

**File:** `backend/src/controllers/scanner.controller.ts`

```typescript
export async function scannerController(fastify: FastifyInstance) {
  // Solve scanned problem
  fastify.post("/scan/solve", async (req: any) => {
    const userId = req.userId;
    const { ocrText, subject, imageUrl } = req.body;
    
    // AI solves the problem
    const solution = await aiService.solveProblem(userId, ocrText, subject);
    
    // Save to database
    const saved = await prisma.scannedProblem.create({
      data: {
        userId,
        subject: subject || solution.topic.split(" - ")[0],
        topic: solution.topic,
        imageUrl,
        ocrText,
        solution: solution.solution,
        explanation: solution.explanation,
      },
    });
    
    return {
      ok: true,
      solution: solution.solution,
      explanation: solution.explanation,
      topic: solution.topic,
      steps: solution.steps,
      savedId: saved.id,
    };
  });
  
  // Get scan history
  fastify.get("/scan/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 20 } = req.query as any;
    
    const scans = await prisma.scannedProblem.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
    
    return { scans };
  });
}
```

### 🎥 Video Controller (NEW)

**File:** `backend/src/controllers/video.controller.ts`

```typescript
export async function videoController(fastify: FastifyInstance) {
  // Summarize video
  fastify.post("/video/summarize", async (req: any) => {
    const userId = req.userId;
    const { title, transcript, url } = req.body;
    
    // AI summarizes
    const summary = await aiService.summarizeVideo(userId, transcript, title);
    
    // Save to database
    const saved = await prisma.videoSummary.create({
      data: {
        userId,
        title,
        url,
        subject: summary.subject,
        topic: summary.topic,
        transcript,
        summary: summary.summary,
        keyPoints: summary.keyPoints,
      },
    });
    
    return {
      ok: true,
      summary: summary.summary,
      keyPoints: summary.keyPoints,
      concepts: summary.concepts,
      savedId: saved.id,
    };
  });
  
  // Get video history
  fastify.get("/video/history", async (req: any) => {
    const userId = req.userId;
    const { limit = 20 } = req.query as any;
    
    const videos = await prisma.videoSummary.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      take: limit,
    });
    
    return { videos };
  });
}
```

### 🤖 Projects Controller (Canvas/Neural Tab) - NEW

**File:** `backend/src/controllers/projects.controller.ts`

```typescript
export async function projectsController(fastify: FastifyInstance) {
  // Get all projects
  fastify.get("/projects", async (req: any) => {
    const userId = req.userId;
    
    const projects = await prisma.project.findMany({
      where: { userId },
      orderBy: { lastActive: "desc" },
      include: {
        messages: {
          take: 1,
          orderBy: { createdAt: "desc" },
        },
      },
    });
    
    return { projects };
  });
  
  // Create project
  fastify.post("/projects", async (req: any) => {
    const userId = req.userId;
    const { name, emoji, description, pinned } = req.body;
    
    const project = await prisma.project.create({
      data: {
        userId,
        name,
        emoji,
        description,
        pinned,
      },
    });
    
    return { ok: true, project };
  });
  
  // Get messages for a project
  fastify.get("/projects/:id/messages", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    
    // Verify ownership
    const project = await prisma.project.findUnique({
      where: { id, userId },
    });
    
    if (!project) {
      throw new Error("Project not found");
    }
    
    const messages = await prisma.message.findMany({
      where: { projectId: id },
      orderBy: { createdAt: "asc" },
    });
    
    return { messages };
  });
  
  // Send message in project (AI responds)
  fastify.post("/projects/:id/message", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    const { content } = req.body;
    
    // Save user message
    const userMsg = await prisma.message.create({
      data: {
        projectId: id,
        role: "user",
        content,
      },
    });
    
    // Get conversation history
    const history = await prisma.message.findMany({
      where: { projectId: id },
      orderBy: { createdAt: "asc" },
      take: 20, // last 20 messages
    });
    
    // Generate AI response (using consciousness)
    const aiResponse = await aiService.generateProjectReply(
      userId,
      content,
      history
    );
    
    // Save AI message
    const assistantMsg = await prisma.message.create({
      data: {
        projectId: id,
        role: "assistant",
        content: aiResponse,
      },
    });
    
    // Update project lastActive
    await prisma.project.update({
      where: { id },
      data: { lastActive: new Date() },
    });
    
    return {
      ok: true,
      userMessage: userMsg,
      aiMessage: assistantMsg,
    };
  });
  
  // Delete project
  fastify.delete("/projects/:id", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    
    await prisma.project.delete({
      where: { id, userId },
    });
    
    return { ok: true };
  });
}
```

### 🎯 Study Targets Controller (NEW)

**File:** `backend/src/controllers/study-targets.controller.ts`

```typescript
export async function studyTargetsController(fastify: FastifyInstance) {
  // Sync targets from Flutter app
  fastify.post("/targets", async (req: any) => {
    const userId = req.userId;
    const { title, description, emoji, startDate, endDate } = req.body;
    
    const target = await prisma.studyTarget.create({
      data: {
        userId,
        title,
        description,
        emoji,
        startDate: new Date(startDate),
        endDate: new Date(endDate),
      },
    });
    
    return { ok: true, target };
  });
  
  // Get all targets
  fastify.get("/targets", async (req: any) => {
    const userId = req.userId;
    
    const targets = await prisma.studyTarget.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
    
    return { targets };
  });
  
  // Toggle complete
  fastify.post("/targets/:id/toggle", async (req: any) => {
    const userId = req.userId;
    const { id } = req.params;
    
    const target = await prisma.studyTarget.findUnique({
      where: { id, userId },
    });
    
    if (!target) throw new Error("Target not found");
    
    const updated = await prisma.studyTarget.update({
      where: { id },
      data: {
        completed: !target.completed,
        completedAt: !target.completed ? new Date() : null,
      },
    });
    
    return { ok: true, target: updated };
  });
}
```

---

## 📋 PHASE 7: SEMANTIC MEMORY ADAPTATION

**File:** `backend/src/services/semanticMemory.service.ts` (UPDATE)

### 🔄 Update Memory Types:

```typescript
type MemoryType = 
  | "brief"           // Keep for backward compat
  | "debrief"         // Keep
  | "nudge"           // Keep
  | "chat"            // Keep
  | "reflection"      // Keep
  // NEW study types:
  | "study_session"   
  | "topic_explanation"
  | "exam_prep"
  | "scan_solve"
  | "video_summary"
  | "mastery_milestone"
  | "weakness_identified"
  | "breakthrough_moment"
  | "intel";          // Daily Intel
```

### ➕ ADD Study-Specific Query Methods:

```typescript
/**
 * Query memories related to a specific topic
 */
async queryTopicMemories(params: {
  userId: string;
  subject: string;
  topic: string;
  limit?: number;
}): Promise<Memory[]> {
  await this.initPromise;
  
  if (!this.isAvailable) return [];
  
  const query = `${params.subject} ${params.topic} explanations concepts`;
  
  const collection = await this.getOrCreateCollection(params.userId);
  const results = await collection.query({
    queryTexts: [query],
    nResults: params.limit || 10,
    where: {
      $or: [
        { type: "topic_explanation" },
        { type: "scan_solve" },
        { type: "video_summary" },
        { type: "study_session" },
      ],
    },
  });
  
  return this.formatResults(results);
}

/**
 * Find similar mistakes/struggles
 */
async findSimilarStruggles(params: {
  userId: string;
  topic: string;
  limit?: number;
}): Promise<Memory[]> {
  await this.initPromise;
  
  if (!this.isAvailable) return [];
  
  const query = `struggling with ${params.topic} confusion mistakes`;
  
  const collection = await this.getOrCreateCollection(params.userId);
  const results = await collection.query({
    queryTexts: [query],
    nResults: params.limit || 5,
  });
  
  return this.formatResults(results);
}
```

---

## 📋 PHASE 8: EVENT TYPES TRANSFORMATION

**Current Event Types (Keep for compatibility):**
- `chat_message`
- `reflection_answer`
- (others can stay dormant)

**New Event Types (Add):**
- `study_session_complete` - When user logs study time
- `exam_created` - New exam added
- `exam_updated` - Threat level changed
- `topic_mastered` - Mastery score > 75%
- `weakness_identified` - Score < 50%
- `target_created` - Study target from Flutter
- `target_completed` - Target checked off
- `scan_solve` - Problem scanned and solved
- `video_summary` - Video summarized
- `daily_intel` - Intel generated
- `study_nudge` - Nudge sent
- `project_created` - New chat project
- `breakthrough_moment` - Significant mastery jump

---

## 📋 PHASE 9: INTEGRATION WITH FLUTTER APP

### 🏠 Home Tab Integration:

**Flutter calls:**
```
GET /exams           → Display threat assessment cards
GET /targets         → Display study targets
GET /study/today     → Show today's progress
GET /intel/latest    → Show daily Intel summary
POST /study/session  → Log study time
POST /targets        → Create new target (from FAB)
```

**Backend fires:**
- 7am: `daily-intel` → Creates CoachMessage
- Flutter fetches on Home tab open
- Displays: Threat Assessment, Today's Missions, Weak Topics

### 🧠 Intel Tab Integration:

**Flutter calls:**
```
GET /intel/latest    → Full Intel report
GET /intel/history   → Past Intel (last 7 days)
GET /mastery         → Topic mastery breakdown
```

**Backend fires:**
- Daily Intel includes:
  - Threat Assessment ✅
  - Critical Alerts ✅
  - Power Analysis (study velocity, mastery rate) ✅
  - Domination Roadmap (priority tasks) ✅

### 🤖 Neural Tab Integration:

**Flutter calls:**
```
GET  /projects              → List all chat sessions
POST /projects              → Create new session
GET  /projects/:id/messages → Load chat history
POST /projects/:id/message  → Send message, get AI reply
DELETE /projects/:id        → Delete session
```

**Backend:**
- AI uses study consciousness for context-aware tutoring
- Remembers previous conversations
- Links to topics and exams

---

## 📋 PHASE 10: SCHEDULER FLOW (Complete Picture)

### ⏰ Daily Schedule:

```
07:00 - Daily Intel Generation
        ├─ Build StudyConsciousness
        ├─ Generate Intel via AI
        ├─ Store as CoachMessage (kind: "intel")
        ├─ Push notification
        └─ Flutter fetches on app open

10:00 - Morning Study Nudge
        ├─ Check if they've studied yet today
        ├─ Check exam proximity
        ├─ Generate context-aware nudge
        └─ Push notification

14:00 - Afternoon Nudge
        ├─ Check drift patterns
        ├─ Check if in drift window
        ├─ Adaptive intensity based on exams
        └─ Push if needed

18:00 - Evening Nudge
        ├─ Check daily progress vs goal
        ├─ Check weak topics
        └─ Push if progress < target

21:00 - Evening Debrief (Optional)
        ├─ Analyze today's sessions
        ├─ Highlight wins/losses
        └─ Set tomorrow's priority
```

### 🚨 Event-Triggered Jobs:

```
ON study_session_complete:
  ├─ Update topic mastery
  ├─ Store in semantic memory
  ├─ Recalculate exam progress
  ├─ Check for mastery milestones
  └─ Update study patterns

ON exam_created:
  ├─ Calculate initial threat level
  ├─ Generate recommended study plan
  └─ Schedule countdown alerts (14d, 7d, 3d, 1d)

ON topic_mastered (score > 75%):
  ├─ Store breakthrough moment
  ├─ Update exam predictions
  └─ Generate celebratory nudge

ON weakness_identified (score < 50% + exam < 14d):
  ├─ Generate urgent nudge
  ├─ Add to priority missions
  └─ Push notification
```

### 📅 Periodic Jobs:

```
Hourly:
  └─ Check exam thresholds (14d, 7d, 3d, 1d alerts)

Every 48h:
  └─ Weak topic push (if stuck topics + upcoming exams)

Weekly (Sunday):
  ├─ Consolidate week's learning
  ├─ Update long-term patterns
  ├─ Generate weekly letter/report
  └─ Recalculate all mastery scores
```

---

## 📋 PHASE 11: MEMORY CATEGORIES & STORAGE

### 🧠 What Gets Stored in Semantic Memory (Chroma):

**Keep storing (for pattern detection):**
- All chat messages (project conversations)
- All nudges and Intel
- Study reflections

**NEW study-specific memories:**
```typescript
// After study session
{
  type: "study_session",
  text: "Studied Organic Chemistry for 45 minutes. Focused on reaction mechanisms. Felt productive.",
  metadata: { subject: "Chemistry", topic: "Organic Reactions", minutes: 45 },
  importance: 3
}

// After scanning problem
{
  type: "scan_solve",
  text: "Solved organic chemistry problem about alkene reactions. Used Markovnikov's rule.",
  metadata: { subject: "Chemistry", topic: "Alkene Reactions" },
  importance: 4
}

// After mastery milestone
{
  type: "mastery_milestone",
  text: "Achieved 80% mastery in Cell Biology. Breakthrough after focused sessions on mitosis.",
  metadata: { subject: "Biology", topic: "Cell Biology", score: 80 },
  importance: 5
}

// When stuck
{
  type: "weakness_identified",
  text: "Still struggling with calculus integration despite 3 sessions. Need different approach.",
  metadata: { subject: "Math", topic: "Integration", attempts: 3 },
  importance: 4
}
```

### 📊 What Gets Stored in UserFacts (Postgres JSON):

```typescript
{
  identity: {
    name: "Alex",
    grade: "Year 11",
    studyGoals: ["Get into Cambridge", "A* in Chemistry"],
    learningStyle: "visual",
  },
  
  // KEEP all pattern analysis
  studyPatterns: {
    peak_study_windows: [{time: "9am-11am", effectiveness: 8.5}],
    drift_windows: [{time: "7pm-9pm", description: "Gaming & YouTube"}],
    consistency_score: 78,
    procrastination_triggers: ["YouTube", "TikTok"],
    return_protocols: ["Pomodoro 25min works best"],
    average_session_minutes: 42,
    best_subjects: ["Biology", "English"],
    struggle_subjects: ["Chemistry", "Math"],
  },
  
  // Study-specific
  examHistory: {
    totalExams: 12,
    averageScore: 76,
    improvement_trend: "ascending",
  },
  
  // KEEP OS phase tracking
  os_phase: {
    current_phase: "architect",
    started_at: "2024-10-01",
    days_in_phase: 45,
    phase_transitions: [...],
  },
}
```

---

## 📋 PHASE 12: SERVER.TS UPDATES

**File:** `backend/src/server.ts`

### 🔄 Update Controller Imports:

```typescript
// REMOVE:
import { reflectionsController } from "./controllers/reflections.controller";
import { futureYouRouter } from "./modules/futureyou/router";
import { lifeTaskRouter } from "./modules/lifetask/router";

// ADD:
import { intelController } from "./controllers/intel.controller";
import { studySessionsController } from "./controllers/study-sessions.controller";
import { examsController } from "./controllers/exams.controller";
import { masteryController } from "./controllers/mastery.controller";
import { scannerController } from "./controllers/scanner.controller";
import { videoController } from "./controllers/video.controller";
import { projectsController } from "./controllers/projects.controller";
import { studyTargetsController } from "./controllers/study-targets.controller";
```

### 🔄 Update Route Registration:

```typescript
fastify.register(async (protectedRoutes) => {
  protectedRoutes.addHook('preHandler', authMiddleware);
  
  // KEEP Core:
  protectedRoutes.register(chatController);      // General chat
  protectedRoutes.register(nudgesController);    // Nudges (adapted)
  protectedRoutes.register(coachController);     // Coach messages
  protectedRoutes.register(systemController);    // System endpoints
  protectedRoutes.register(userController);      // User management
  protectedRoutes.register(insightsController);  // Pattern insights (keep!)
  
  // NEW Study OS:
  protectedRoutes.register(intelController);          // Daily Intel
  protectedRoutes.register(studySessionsController);  // Log sessions
  protectedRoutes.register(examsController);          // Exam management
  protectedRoutes.register(masteryController);        // Topic mastery
  protectedRoutes.register(scannerController);        // OCR + solve
  protectedRoutes.register(videoController);          // Video summaries
  protectedRoutes.register(projectsController);       // Neural tab chats
  protectedRoutes.register(studyTargetsController);   // Flutter targets
  
  // REMOVE (not needed):
  // protectedRoutes.register(whatIfController);
  // protectedRoutes.register(futureYouChatController);
  // protectedRoutes.register(whatIfChatController);
  // protectedRoutes.register(futureYouChatControllerV2);
  // protectedRoutes.register(reflectionsController);
  // protectedRoutes.register(futureYouRouter);
  // protectedRoutes.register(lifeTaskRouter);
});
```

---

## 📋 PHASE 13: COACHMESSAGE ENUM UPDATE

**File:** `backend/prisma/schema.prisma`

```prisma
enum CoachMessageKind {
  nudge
  brief          // Keep for backward compat
  mirror         // Keep
  letter         // Keep
  intel          // NEW - daily Intel
  exam_alert     // NEW - exam countdown
  mastery_alert  // NEW - weak topic push
}
```

---

## 🎯 IMPLEMENTATION CHECKLIST

### Database (Prisma)
- [ ] Remove old models (Habit, AntiHabit, Alarm, etc.)
- [ ] Add new study models (Exam, StudySession, TopicMastery, etc.)
- [ ] Update User model with study fields
- [ ] Update CoachMessageKind enum
- [ ] Create migration file
- [ ] Test migration on dev database

### Services
- [ ] Create `study-intelligence.service.ts` (adapt memory-intelligence)
- [ ] Create `ai-study-prompts.service.ts` (adapt ai-os-prompts)
- [ ] Update `ai.service.ts` (add Intel, scan, video methods)
- [ ] Update `semanticMemory.service.ts` (new memory types)
- [ ] KEEP `memory.service.ts` as-is ✅
- [ ] KEEP `short-term-memory.service.ts` as-is ✅

### Controllers (NEW)
- [ ] Create `intel.controller.ts`
- [ ] Create `study-sessions.controller.ts`
- [ ] Create `exams.controller.ts`
- [ ] Create `mastery.controller.ts`
- [ ] Create `scanner.controller.ts`
- [ ] Create `video.controller.ts`
- [ ] Create `projects.controller.ts`
- [ ] Create `study-targets.controller.ts`

### Scheduler
- [ ] Transform `ensureDailyBriefJobs` → `ensureDailyIntelJobs`
- [ ] Add `checkExamThresholds` (hourly)
- [ ] Add `pushWeakTopics` (every 48h)
- [ ] Add `analyzeStudySession` (event-triggered)
- [ ] Update worker job handlers

### Server
- [ ] Remove unused controllers (futureYou, lifeTask, reflections, whatIf)
- [ ] Register new study controllers
- [ ] Update API docs

### Testing
- [ ] Test Intel generation
- [ ] Test exam threat calculation
- [ ] Test mastery tracking
- [ ] Test scanner pipeline
- [ ] Test scheduler firing
- [ ] Test Flutter ↔ Backend sync

---

## 🔥 KEY TRANSFORMATIONS SUMMARY

| Component | From | To | Status |
|-----------|------|-----|--------|
| **Database** | Habits, Tasks, Alarms | Exams, Sessions, Mastery | Transform |
| **Events** | habit_tick, chat | study_session, intel, scan | Expand |
| **Memory** | Life patterns | Study patterns | Adapt |
| **Intelligence** | buildUserConsciousness | buildStudyConsciousness | Adapt |
| **AI Prompts** | Life coach voice | Study dominator voice | Rewrite |
| **Scheduler** | Brief/Debrief | Intel/Exam Alerts | Transform |
| **Semantic Memory** | Chroma collections | Same (new types) | Expand |
| **3-Phase Engine** | Observer/Architect/Oracle | Same (study context) | Adapt |
| **Pattern Detection** | Habits, drifts | Study times, topics | Adapt |
| **Nudges** | Habit reminders | Exam pressure | Intensify |

---

## 💪 WHAT MAKES THIS BEAST MODE

**1. Adaptive Intensity**
- Normal nudges when exams > 14 days
- High pressure 7-14 days
- NUCLEAR MODE < 7 days + low mastery
- Uses same voice calibration system you built

**2. Pattern-Powered Intelligence**
- Knows when they study best (peak windows)
- Knows when they procrastinate (drift windows)
- Detects recurring excuses from semantic memory
- Tracks what actually works (return protocols)

**3. Predictive Threat System**
- Real-time exam threat calculation
- Mastery-based outcome prediction
- Gap analysis (what topics will hurt them)
- Recommended hours to hit target grade

**4. Multi-Modal Learning**
- Scanner: OCR → Solve → Memory
- Video: Transcript → Summary → Concepts
- Chat: Tutoring with full consciousness
- Sessions: Manual logging → Pattern extraction

**5. Memory That Actually Helps**
- Similar struggles retrieval
- Topic-specific memory queries
- Breakthrough moment tracking
- Contradiction detection (says vs does)

**6. 3-Phase Evolution**
- Observer (2 weeks): Learn their patterns
- Architect (2-8 weeks): Build study systems
- Oracle (8+ weeks): Wisdom-level pressure

---

## 🚀 EXECUTION ORDER

1. **Database** - Schema transformation (1-2 hours)
2. **Study Intelligence** - Adapt consciousness builder (2-3 hours)
3. **AI Prompts** - Rewrite for study context (2 hours)
4. **AI Service** - Add Intel/scan/video methods (2 hours)
5. **Controllers** - Create all 8 new controllers (3-4 hours)
6. **Scheduler** - Transform jobs (1-2 hours)
7. **Server** - Wire everything up (30 min)
8. **Testing** - End-to-end verification (2 hours)
9. **Flutter Integration** - Connect API calls (1 hour)

**Total:** ~15-20 hours of focused work

---

## 🎯 SUCCESS CRITERIA

✅ Daily Intel fires at 7am automatically  
✅ Displays in Flutter Home + Intel tabs  
✅ Exam threats calculate correctly  
✅ Nudges intensify as exams approach  
✅ Study sessions update mastery  
✅ Scanner solves problems and stores in memory  
✅ Video summaries extract concepts  
✅ Neural tab chat uses consciousness  
✅ Patterns detect study behavior  
✅ Semantic memory works for topic queries  
✅ **All existing memory/intelligence power PRESERVED**  

---

## 💎 THE VISION

When complete, you'll have:

**The user opens the app:**
1. Home tab shows Daily Intel (auto-generated at 7am)
2. Threat Assessment with live exam countdowns
3. Today's Missions (AI-prioritized based on mastery + exams)
4. Study Targets (user-created, tickable)

**The Intel tab shows:**
1. Full Intel report (threats, weaknesses, predictions, roadmap)
2. Critical Alerts (powered by pattern detection)
3. Power Analysis (study velocity from session tracking)
4. Domination Roadmap (AI-generated, exam-aware)

**Throughout the day:**
- 10am: Nudge if they haven't studied
- 2pm: Nudge if in drift window
- 6pm: Nudge if behind on goals
- Exam alerts at 14d, 7d, 3d, 1d thresholds
- Intensity CRANKS UP as exams approach

**Everything powered by:**
- Semantic memory (Chroma embeddings)
- Pattern extraction (your existing algorithms)
- 3-phase AI engine (consciousness-based generation)
- Redis scheduler (auto-firing)
- Behavioral contradiction detection (calls them out)

**THIS IS THE BEAST. 🧠🔥**

---

Ready to execute this plan bro? Say the word and I'll start with the database transformation.

