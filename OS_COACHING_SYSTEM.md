# 🧠 OS COACHING SYSTEM - Proactive Intelligence + Action

## THE VISION: SMART GUIDANCE, NOT JUST ANALYSIS

**Current State:**
- OS knows: "Organic Chemistry is weak (40%)"
- OS says: "You're weak at Organic Chemistry"
- User thinks: "...okay, now what?"

**What We Need:**
- OS knows: "Organic Chemistry is weak (40%), Chemistry exam in 5 days"
- OS says: "You're weak at Organic Chemistry (40%). Let's do **10 min/day focused practice** to catch up. I've prepared **20 flashcards** on the exact concepts you're missing. Start now?"
- User clicks: **"Generate Flashcards"** → Instant practice, topic-specific

**THAT'S THE WEAPON.** Intelligence + Action.

---

## 📍 WHERE OS MESSAGES LIVE IN THE APP

### **NEW SECTION: "AI Coach" (Command Tab)**

Replace "Critical Alerts" with **"AI Coach"** - a persistent feed of smart, actionable guidance:

```
╔══════════════════════════════════════════════════╗
║  COMMAND TAB (Mission Control)                   ║
╠══════════════════════════════════════════════════╣
║  [Header: Date, Streak]                          ║
║                                                   ║
║  📊 AI COACH ─────────────────────────────────   ║
║                                                   ║
║  ┌──────────────────────────────────────────┐   ║
║  │ 🎯 Chemistry Exam in 4 Days              │   ║
║  │                                           │   ║
║  │ Weak Areas:                               │   ║
║  │ • Organic Reactions (40%)                 │   ║
║  │ • Acid-Base Equilibrium (45%)             │   ║
║  │                                           │   ║
║  │ SMART PLAN:                               │   ║
║  │ 10 min/day focused practice (4 days)      │   ║
║  │ = 40 min total = +15% mastery boost       │   ║
║  │                                           │   ║
║  │ [📇 Generate Flashcards] [🧪 Start Quiz] │   ║
║  └──────────────────────────────────────────┘   ║
║                                                   ║
║  ┌──────────────────────────────────────────┐   ║
║  │ ⚠️ 3-Day Drift on Integration            │   ║
║  │                                           │   ║
║  │ Last session: Nov 20 (47 min)             │   ║
║  │ Mastery decay: 68% → 58% (-10%)           │   ║
║  │                                           │   ║
║  │ RECOVERY PLAN:                            │   ║
║  │ 15 min session today to stop decay        │   ║
║  │                                           │   ║
║  │ [📝 Quick Review] [🎥 Watch Explanation]  │   ║
║  └──────────────────────────────────────────┘   ║
║                                                   ║
║  ┌──────────────────────────────────────────┐   ║
║  │ 💪 Momentum Opportunity                   │   ║
║  │                                           │   ║
║  │ You're in peak window (9-11 AM)           │   ║
║  │ Mastery gains: +12% avg during this time  │   ║
║  │                                           │   ║
║  │ SUGGESTED:                                │   ║
║  │ Attack hardest topic now (Organic Chem)   │   ║
║  │                                           │   ║
║  │ [🚀 Start Deep Dive] [📸 Scan Problems]   │   ║
║  └──────────────────────────────────────────┘   ║
║                                                   ║
║  [Power Stats Grid]                              ║
║  [Weekly Target Slider]                          ║
║  [Study Trajectory]                              ║
╚══════════════════════════════════════════════════╝
```

**Key Features:**
1. **Persistent Feed:** Messages stay until user acts on them
2. **Actionable Buttons:** Tap to generate flashcards, quizzes, etc.
3. **Context-Aware:** Each message includes WHY (exam in X days, mastery at Y%)
4. **Smart Plans:** Not just "study more" - specific time estimates and predicted outcomes

---

## 🤖 BACKEND: SMART MESSAGE GENERATION

### **New AI Service Method: `generateSmartCoaching(userId)`**

```typescript
// backend/src/services/ai.service.ts

async generateSmartCoaching(userId: string): Promise<CoachingMessage[]> {
  const intel = await buildUserIntelState(userId);
  const messages: CoachingMessage[] = [];

  // 1. EXAM PREP MESSAGES
  for (const exam of intel.exams) {
    if (exam.daysRemaining <= 7 && exam.deficit > 0) {
      // Find weak topics for this exam subject
      const weakTopics = intel.mastery.weakTopics.filter(topic => 
        topic.toLowerCase().includes(exam.subject.toLowerCase())
      );

      if (weakTopics.length > 0) {
        messages.push({
          type: "exam_prep",
          priority: exam.threatLevel === "CRITICAL" ? "high" : "medium",
          title: `${exam.subject} Exam in ${exam.daysRemaining} Days`,
          weakAreas: weakTopics.map(t => ({
            topic: t.split(' - ')[0],
            mastery: parseInt(t.match(/\d+/)?.[0] || "0")
          })),
          plan: {
            description: `10 min/day focused practice (${exam.daysRemaining} days)`,
            totalTime: exam.daysRemaining * 10,
            predictedGain: 15, // +15% mastery
            breakdown: [
              `Day 1-2: ${weakTopics[0]} fundamentals`,
              `Day 3-4: ${weakTopics[1]} practice`,
              `Day 5+: Mixed review`
            ]
          },
          actions: [
            {
              type: "flashcards",
              label: "Generate Flashcards",
              payload: { topics: weakTopics, count: 20, difficulty: "medium" }
            },
            {
              type: "quiz",
              label: "Start Quiz",
              payload: { topics: weakTopics, questions: 10, adaptive: true }
            },
            {
              type: "deep_dive",
              label: "Deep Dive Lesson",
              payload: { topic: weakTopics[0] }
            }
          ]
        });
      }
    }
  }

  // 2. DRIFT RECOVERY MESSAGES
  for (const pattern of intel.studyPatterns.driftWindows || []) {
    const daysSinceLast = pattern.daysSinceLastSession;
    if (daysSinceLast >= 3) {
      messages.push({
        type: "drift_recovery",
        priority: "medium",
        title: `${daysSinceLast}-Day Drift on ${pattern.subject}`,
        context: {
          lastSession: pattern.lastSessionDate,
          lastDuration: pattern.lastDuration,
          masteryDecay: pattern.masteryDecay || 10
        },
        plan: {
          description: "15 min session today to stop decay",
          totalTime: 15,
          urgency: "Recovery session - prevent further loss"
        },
        actions: [
          {
            type: "quick_review",
            label: "Quick Review",
            payload: { topic: pattern.subject, duration: 15 }
          },
          {
            type: "video",
            label: "Watch Explanation",
            payload: { topic: pattern.subject }
          }
        ]
      });
    }
  }

  // 3. MOMENTUM OPPORTUNITY MESSAGES
  const now = new Date();
  const currentHour = now.getHours();
  const peakWindow = intel.studyPatterns.peakPerformanceWindow; // e.g., "9-11 AM"
  
  if (peakWindow) {
    const [start, end] = peakWindow.split('-').map(t => parseInt(t));
    if (currentHour >= start && currentHour < end) {
      // In peak window - suggest hardest topic
      const hardestTopic = intel.mastery.weakTopics[0];
      
      messages.push({
        type: "momentum",
        priority: "high",
        title: "Momentum Opportunity",
        context: {
          peakWindow,
          masteryBoost: "+12% avg during this time"
        },
        plan: {
          description: `Attack hardest topic now (${hardestTopic})`,
          totalTime: 30,
          reasoning: "Peak cognitive performance detected"
        },
        actions: [
          {
            type: "deep_dive",
            label: "Start Deep Dive",
            payload: { topic: hardestTopic }
          },
          {
            type: "scan",
            label: "Scan Problems",
            payload: { topic: hardestTopic }
          }
        ]
      });
    }
  }

  // 4. CONSISTENCY BUILDER MESSAGES
  if (intel.studyPatterns.consistencyScore < 60) {
    messages.push({
      type: "consistency",
      priority: "low",
      title: "Build Study Consistency",
      context: {
        currentStreak: intel.identity.streak || 0,
        targetStreak: 7,
        consistencyScore: intel.studyPatterns.consistencyScore
      },
      plan: {
        description: "5 min daily check-ins for 7 days",
        totalTime: 35,
        predictedGain: "+25% consistency score"
      },
      actions: [
        {
          type: "micro_session",
          label: "Start 5-Min Session",
          payload: { duration: 5 }
        }
      ]
    });
  }

  return messages.sort((a, b) => {
    const priorityOrder = { high: 0, medium: 1, low: 2 };
    return priorityOrder[a.priority] - priorityOrder[b.priority];
  });
}
```

---

## 📱 FRONTEND: ACTIONABLE UI

### **New Widget: `CoachingMessageCard`**

```dart
// lib/widgets/coaching_message_card.dart

class CoachingMessageCard extends StatelessWidget {
  final CoachingMessage message;

  const CoachingMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: EdgeInsets.all(DesignTokens.space20),
      borderColor: _getPriorityColor(message.priority).withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(DesignTokens.space12),
                decoration: BoxDecoration(
                  color: _getPriorityColor(message.priority).withOpacity(0.15),
                  borderRadius: DesignTokens.borderRadiusSmall,
                ),
                child: Icon(
                  _getTypeIcon(message.type),
                  color: _getPriorityColor(message.priority),
                  size: 24,
                ),
              ),
              SizedBox(width: DesignTokens.space16),
              Expanded(
                child: Text(
                  message.title,
                  style: DesignTokens.heading3,
                ),
              ),
            ],
          ),

          SizedBox(height: DesignTokens.space16),

          // Weak Areas (if exam prep)
          if (message.weakAreas != null) ...[
            Text('Weak Areas:', style: DesignTokens.labelMedium),
            SizedBox(height: DesignTokens.space8),
            ...message.weakAreas!.map((area) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text('• ${area.topic}', style: DesignTokens.bodyMedium),
                  SizedBox(width: DesignTokens.space8),
                  Text(
                    '(${area.mastery}%)',
                    style: DesignTokens.labelSmall.copyWith(
                      color: DesignTokens.getMasteryColor(area.mastery.toDouble()),
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: DesignTokens.space16),
          ],

          // Smart Plan
          Container(
            padding: EdgeInsets.all(DesignTokens.space16),
            decoration: BoxDecoration(
              color: DesignTokens.backgroundTertiary,
              borderRadius: DesignTokens.borderRadiusSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SMART PLAN:', style: DesignTokens.labelSmall),
                SizedBox(height: DesignTokens.space8),
                Text(
                  message.plan.description,
                  style: DesignTokens.bodyMedium,
                ),
                if (message.plan.predictedGain != null) ...[
                  SizedBox(height: DesignTokens.space8),
                  Text(
                    '= +${message.plan.predictedGain}% mastery boost',
                    style: DesignTokens.labelMedium.copyWith(
                      color: DesignTokens.success,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: DesignTokens.space16),

          // Action Buttons
          Wrap(
            spacing: DesignTokens.space8,
            runSpacing: DesignTokens.space8,
            children: message.actions.map((action) => 
              ElevatedButton.icon(
                onPressed: () => _handleAction(context, action),
                icon: Icon(_getActionIcon(action.type), size: 18),
                label: Text(action.label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary.withOpacity(0.15),
                  foregroundColor: DesignTokens.primary,
                  elevation: 0,
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, CoachingAction action) {
    switch (action.type) {
      case 'flashcards':
        // Navigate to Flashcard Turbo with pre-loaded topics
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlashcardScreen(
              topics: action.payload['topics'],
              count: action.payload['count'],
              autoGenerate: true,
            ),
          ),
        );
        break;

      case 'quiz':
        // Navigate to Quiz with pre-configured settings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              topics: action.payload['topics'],
              questions: action.payload['questions'],
              adaptive: action.payload['adaptive'],
            ),
          ),
        );
        break;

      case 'deep_dive':
        // Navigate to Deep Dive with specific topic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeepDiveScreen(
              topic: action.payload['topic'],
            ),
          ),
        );
        break;

      case 'scan':
        // Open AI Scanner
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AIScannerScreen()),
        );
        break;

      case 'video':
        // Navigate to Video Mastery
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoMasteryScreen(
              suggestedTopic: action.payload['topic'],
            ),
          ),
        );
        break;

      case 'quick_review':
        // Start quick review session
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuickReviewScreen(
              topic: action.payload['topic'],
              duration: action.payload['duration'],
            ),
          ),
        );
        break;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return DesignTokens.error;
      case 'medium': return DesignTokens.warning;
      default: return DesignTokens.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'exam_prep': return LucideIcons.target;
      case 'drift_recovery': return LucideIcons.alertTriangle;
      case 'momentum': return LucideIcons.zap;
      case 'consistency': return LucideIcons.trendingUp;
      default: return LucideIcons.lightbulb;
    }
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'flashcards': return LucideIcons.layers;
      case 'quiz': return LucideIcons.checkSquare;
      case 'deep_dive': return LucideIcons.bookOpen;
      case 'scan': return LucideIcons.scan;
      case 'video': return LucideIcons.playCircle;
      default: return LucideIcons.arrowRight;
    }
  }
}
```

---

## 🔄 INTEGRATION FLOW

### **1. Backend Generates Coaching Messages (Hourly)**

```typescript
// backend/src/jobs/scheduler.ts

async function generateCoachingMessages() {
  const users = await prisma.user.findMany({ 
    where: { coachingEnabled: true } 
  });

  for (const user of users) {
    const messages = await aiService.generateSmartCoaching(user.id);
    
    // Store each message
    for (const msg of messages) {
      await prisma.coachingMessage.create({
        data: {
          userId: user.id,
          type: msg.type,
          priority: msg.priority,
          title: msg.title,
          content: JSON.stringify(msg),
          status: 'active',
          expiresAt: msg.type === 'momentum' 
            ? new Date(Date.now() + 2 * 60 * 60 * 1000) // 2 hours
            : new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours
        }
      });
    }
  }
}

// Add to scheduler
await schedulerQueue.add("coaching-messages", {}, {
  repeat: { every: 60 * 60_000 }, // Every hour
});
```

### **2. Frontend Fetches Active Messages**

```dart
// lib/services/api_service.dart

Future<List<CoachingMessage>> getCoachingMessages() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/coaching/messages'),
    headers: _getHeaders(),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List;
    return data.map((m) => CoachingMessage.fromJson(m)).toList();
  }
  return [];
}

Future<void> dismissMessage(String messageId) async {
  await http.post(
    Uri.parse('$baseUrl/api/coaching/messages/$messageId/dismiss'),
    headers: _getHeaders(),
  );
}

Future<void> completeAction(String messageId, String actionType) async {
  await http.post(
    Uri.parse('$baseUrl/api/coaching/messages/$messageId/complete'),
    headers: _getHeaders(),
    body: json.encode({'actionType': actionType}),
  );
}
```

### **3. Display in Command Tab**

```dart
// lib/tabs/home_tab.dart

Widget _buildAICoach(BuildContext context) {
  return FutureBuilder<List<CoachingMessage>>(
    future: ApiService.getCoachingMessages(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return _buildEmptyCoach();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Coach', style: DesignTokens.heading1),
          SizedBox(height: DesignTokens.space16),
          ...snapshot.data!.map((msg) => Padding(
            padding: EdgeInsets.only(bottom: DesignTokens.space16),
            child: CoachingMessageCard(message: msg),
          )),
        ],
      );
    },
  );
}
```

---

## 🎯 EXAMPLE: FULL COACHING FLOW

### **User: Sarah, Chemistry Exam in 5 Days**

**7:00 AM - Daily Intel Runs:**
```
Intelligence State:
- Chemistry exam: 5 days away
- Weak topics: Organic Reactions (40%), Acid-Base (45%)
- Study deficit: 8.8 hours
- Pass probability: 67%
```

**7:05 AM - Coaching Message Generated:**
```json
{
  "type": "exam_prep",
  "priority": "high",
  "title": "Chemistry Exam in 5 Days",
  "weakAreas": [
    { "topic": "Organic Reactions", "mastery": 40 },
    { "topic": "Acid-Base Equilibrium", "mastery": 45 }
  ],
  "plan": {
    "description": "10 min/day focused practice (5 days)",
    "totalTime": 50,
    "predictedGain": 15,
    "breakdown": [
      "Day 1-2: Organic Reactions fundamentals",
      "Day 3-4: Acid-Base practice",
      "Day 5: Mixed review"
    ]
  },
  "actions": [
    {
      "type": "flashcards",
      "label": "Generate Flashcards",
      "payload": { "topics": ["Organic Reactions", "Acid-Base"], "count": 20 }
    },
    {
      "type": "quiz",
      "label": "Start Quiz",
      "payload": { "topics": ["Organic Reactions"], "questions": 10 }
    }
  ]
}
```

**7:06 AM - User Opens App:**

```
╔═══════════════════════════════════════╗
║  📊 AI COACH                          ║
║                                        ║
║  🎯 Chemistry Exam in 5 Days          ║
║                                        ║
║  Weak Areas:                           ║
║  • Organic Reactions (40%)             ║
║  • Acid-Base Equilibrium (45%)         ║
║                                        ║
║  SMART PLAN:                           ║
║  10 min/day focused practice (5 days)  ║
║  = +15% mastery boost                  ║
║                                        ║
║  Day 1-2: Organic Reactions            ║
║  Day 3-4: Acid-Base practice           ║
║  Day 5: Mixed review                   ║
║                                        ║
║  [📇 Generate Flashcards]              ║
║  [🧪 Start Quiz]                       ║
╚═══════════════════════════════════════╝
```

**User Taps "Generate Flashcards":**
1. App calls backend: `POST /api/flashcards/generate`
2. Backend uses AI to generate 20 flashcards on Organic Reactions
3. Flashcard screen opens with pre-loaded cards
4. User studies for 10 minutes
5. Backend records session, updates mastery: 40% → 48%

**Next Day - Updated Coaching:**
```
╔═══════════════════════════════════════╗
║  📊 AI COACH                          ║
║                                        ║
║  ✅ Progress on Organic Reactions     ║
║  Mastery: 40% → 48% (+8%)              ║
║                                        ║
║  🎯 Chemistry Exam in 4 Days          ║
║                                        ║
║  Next Focus: Acid-Base Equilibrium     ║
║  10 min session today                  ║
║                                        ║
║  [📇 Generate Flashcards]              ║
║  [🎥 Watch Video Lesson]               ║
╚═══════════════════════════════════════╝
```

---

## 🔥 WHY THIS IS A WEAPON

**Other Apps:**
- "You have a chemistry exam soon"
- "Study chemistry"
- User: "...with what? how? where do I start?"

**Cerebellum OS:**
1. **Identifies Weakness:** "Organic Reactions: 40% mastery"
2. **Calculates Impact:** "Chemistry exam in 5 days, 67% pass probability"
3. **Creates Plan:** "10 min/day for 5 days = +15% mastery = 82% pass probability"
4. **Provides Tools:** Tap button → Instant flashcards on EXACTLY that topic
5. **Tracks Progress:** "Organic Reactions: 40% → 48% (+8%)"
6. **Adapts:** "Good progress. Now focus on Acid-Base next."

**IT'S NOT A STUDY APP. IT'S A PERSONAL COACH WITH A TOOLKIT.**

---

## 📋 IMPLEMENTATION CHECKLIST

### **Backend:**
- [ ] Create `CoachingMessage` database model
- [ ] Implement `generateSmartCoaching()` in AI service
- [ ] Add hourly coaching message generation job
- [ ] Create API endpoints: `/api/coaching/messages`, `/api/coaching/messages/:id/dismiss`
- [ ] Implement message expiration logic

### **Frontend:**
- [ ] Create `CoachingMessage` model class
- [ ] Build `CoachingMessageCard` widget
- [ ] Add AI Coach section to Command Tab
- [ ] Integrate action buttons with learning tools (flashcards, quiz, etc.)
- [ ] Add message dismissal functionality
- [ ] Show progress updates when user completes actions

### **Learning Tools Integration:**
- [ ] Flashcard screen: Accept pre-configured topics
- [ ] Quiz screen: Accept topic + difficulty presets
- [ ] Deep Dive: Accept starting topic
- [ ] Video Mastery: Accept suggested topic search

**THEN IT'S A COMPLETE SYSTEM: OBSERVE → ANALYZE → GUIDE → ACT → IMPROVE → REPEAT** 🚀

