# 🧠 CEREBELLUM AI OS - DAILY INTELLIGENCE FLOW

## 📅 WHAT HAPPENS EVERY DAY

### 🌅 **1. MORNING INTELLIGENCE GENERATION** (6:00 AM)

**What it does:**
- Analyzes your last 7 days of study sessions
- Checks upcoming exams (next 30 days)
- Reviews your topic mastery levels
- Detects behavior patterns (procrastination, peak times, drift windows)
- Calculates exam threat levels
- Identifies weak topics

**What it generates:**
```
{
  fullText: "Comprehensive daily intelligence report",
  threatAssessment: "Exam threat analysis",
  weaknesses: ["Topic 1", "Topic 2", ...],
  predictions: "What will happen if you continue current trajectory",
  todaysMissions: ["Mission 1", "Mission 2", ...],
  insights: "Behavioral insights (when you study best, what you avoid, etc.)"
}
```

**Where it goes:**
- Saved to database as `CoachMessage` (type: `daily_intel`)
- **DISPLAYED IN:** Intel Tab → "ELITE AI INSIGHTS" card (top of the page)
- Also used to populate "TODAY'S MISSIONS" cards
- Threat Assessment shown in Command Tab

---

### 📊 **2. CONTINUOUS PATTERN DETECTION** (All Day)

**Triggers:**
- After every study session you log
- When you mark a task complete
- When you add an exam
- When you update topic mastery

**What it does:**
- Updates your **Study Identity** (Momentum Builder, Drift Cycler, Last-Minute Sprinter, etc.)
- Recalculates **exam threats** in real-time
- Tracks **study streaks**
- Monitors **weekly study minutes**
- Detects **procrastination triggers**

**Where it goes:**
- Command Tab → Power stats (IQ, Power, Mastery, Streak)
- Command Tab → Intensity Slider (based on recent activity)
- Intel Tab → Archive stats (Total Study Hours, Peak Streak, etc.)

---

### 🎯 **3. STUDY NUDGES** (Smart Timing)

**Triggers:**
- You haven't studied in 24+ hours → "drift_alert"
- Exam in < 7 days + low prep → "exam_threat"
- You complete a streak milestone → "streak_milestone"
- Peak study time approaching → "peak_window"

**What it does:**
- Generates a SHORT, BRUTAL nudge (1-3 sentences)
- Example: *"Chemistry exam in 4 DAYS. You've studied 3 hours total. You need 12 MORE to pass. Today. Not tomorrow."*

**Where it goes:**
- Saved as `CoachMessage` (type: `nudge`)
- **DISPLAYED AS:** Push notification (if implemented)
- Also shown in Intel Tab if recent

---

### 🧪 **4. SEMANTIC MEMORY** (Continuous)

**What it tracks:**
- Your **recurring excuses** (e.g., "I'll do it tomorrow")
- **Contradictions** (e.g., you say math is priority but study biology more)
- **Breakthroughs** (topics you suddenly mastered)
- **Chat history** from Neural Canvas

**Where it goes:**
- Stored in **ChromaDB** (vector database for semantic search)
- Used by AI to **call you out** on patterns
- Example: *"You said 'tomorrow' 8 times this week for chemistry. Exam is TOMORROW."*

---

## 📍 WHERE AI OS OUTPUT IS DISPLAYED

### **COMMAND TAB (Home)**
- **Power Stats** (top 4 cards): IQ, Power, Mastery, Streak
- **Critical Alerts**: Real-time exam threats
- **Study Intensity Slider**: Current weekly minutes vs target
- **Domination Roadmap**: Next 3 study goals
- **Today's Missions**: From daily intel

### **INTEL TAB (Teacher)**
- **ELITE AI INSIGHTS** (top card): Full daily intelligence report
- **TODAY'S MISSIONS**: 4 time-blocked study tasks
- **BEHAVIORAL INSIGHTS**: Patterns, procrastination triggers, peak times
- **Archive Stats**: Total study hours, peak streak, sessions, concepts mastered

### **NEURAL TAB (Canvas)**
- **AI Chat**: Ask anything, get study advice
- Uses your **full intelligence state** for context:
  - Knows your exams
  - Knows your weak topics
  - Knows your study patterns
  - Calls you out on contradictions

---

## 🤖 AI MODELS USED

| Task | Model | Why |
|------|-------|-----|
| Daily Intel | **GPT-4o** | Best reasoning, pattern analysis |
| Study Nudges | **GPT-4o** | Needs brutal honesty, context |
| Neural Canvas Chat | **GPT-4o** | Best conversational AI |
| Flashcard Generation | **DeepSeek V3** | Fast, cheap, good quality |
| Quiz Generation | **DeepSeek V3** | Fast, cheap, good quality |
| Video Summarization | **DeepSeek V3** | Fast, cheap, good quality |
| Image OCR | **Google Vision + Tesseract** | OCR specialists |
| Problem Solving | **GPT-4o** | Needs deep reasoning |

---

## ⏰ SCHEDULER (Background Worker)

**Runs on Railway in separate process:**

```javascript
// Every day at 6:00 AM
cron.schedule('0 6 * * *', async () => {
  // Get all users
  const users = await getAllUsers();
  
  for (const user of users) {
    // Generate daily intelligence
    await aiService.generateDailyIntel(user.id);
    
    // Check for nudge triggers
    await checkStudyNudges(user.id);
  }
});
```

**Nudge checks (every 2 hours):**
- Drift alerts
- Exam threats
- Peak window reminders

---

## 🔥 TL;DR - WHAT THE AI OS DOES

1. **MORNING (6 AM)**: Generates full intelligence report → Intel Tab
2. **ALL DAY**: Tracks your behavior, updates patterns → Command Tab stats
3. **SMART TIMING**: Sends brutal nudges when you're slacking → Notifications
4. **ALWAYS ON**: Neural Canvas knows your full study state → Personalized advice
5. **NEVER FORGETS**: Semantic memory tracks your excuses, contradictions, breakthroughs

---

## 🚀 WHAT'S MISSING (Not Yet Implemented)

- **Push Notifications** (nudges currently only saved to DB, not sent)
- **Welcome Series** (7-day onboarding messages)
- **Weekly Reflection** (every Sunday, deep dive into patterns)
- **ChromaDB** (semantic memory disabled on Railway, needs separate service)

---

**Bottom line:** The AI OS is a **24/7 study coach** that knows your patterns, tracks your excuses, predicts your failures, and pushes you to dominate. It's not a helper, it's a drill sergeant.

