# 🧠 AI INTEGRATION ROADMAP

**Status:** Cerebellum Study OS backend has AI endpoints but Flutter app uses MOCK DATA

This document maps **what exists**, **what's missing**, and **what needs to be connected**.

---

## 📊 CURRENT STATUS

### ✅ BACKEND ENDPOINTS (Already Implemented)

| Endpoint | Purpose | AI Function | Status |
|----------|---------|-------------|--------|
| `GET /intel/latest` | Daily Intel | `generateDailyIntel()` | ✅ Working |
| `POST /intel/regenerate` | Force new Intel | `generateDailyIntel()` | ✅ Working |
| `POST /scan/solve` | OCR + AI solve | `solveProblem()` | ✅ Working |
| `POST /video/summarize` | Video → concepts | `summarizeVideo()` | ✅ Working |
| `POST /projects/:id/message` | Neural chat | `chatWithStudyOS()` | ✅ Working |
| `POST /api/v1/chat` | General chat | `nextMessage()` | ✅ Working |
| `GET /exams` | Get exams | N/A | ✅ DB only |
| `GET /mastery` | Topic mastery | N/A | ✅ DB only |
| `GET /study-sessions` | Study history | N/A | ✅ DB only |

---

## ❌ FLUTTER MOCK DATA (Needs Integration)

### 1. 🏠 **HOME TAB** (`lib/tabs/home_tab.dart`)

**Current:** All hardcoded mock data  
**Needs:** Connect to backend APIs

| UI Element | Current Data | Needs Endpoint | Backend Source |
|------------|-------------|----------------|----------------|
| 4 Archive Cards | Hardcoded `247h`, `28 Days`, `186`, `142` | `GET /stats/summary` | Calculate from `studySession`, exams, mastery |
| Critical Alerts | Hardcoded 3 alerts | `GET /intel/latest` | `threatAssessment` from Daily Intel |
| Today's Missions | Hardcoded 4 missions | `GET /intel/latest` | `todaysMissions` from Daily Intel |
| Study Targets | Local storage only | `GET /study-targets` + `POST /study-targets` | Already exists! |
| Domination Roadmap | Hardcoded 3 tasks | `GET /intel/latest` | `todaysMissions` (priority tasks) |
| Intensity Slider | Local state only | Should save to DB | `PATCH /user/intensity` |

**ACTION NEEDED:**
- Create `GET /stats/summary` endpoint
- Fetch Daily Intel on tab load
- Parse Intel sections into UI components
- Save intensity preference to user profile

---

### 2. 🧠 **INTEL TAB** (`lib/tabs/teacher_tab.dart`)

**Current:** All mock/hardcoded data  
**Needs:** Real AI-generated intelligence

| UI Element | Current Data | Needs Endpoint | Backend Source |
|------------|-------------|----------------|----------------|
| Elite AI Insights Card | Hardcoded threat/weak/predictions | `GET /intel/latest` | Full Daily Intel object |
| Identity Engine | Hardcoded `Momentum Builder` | `GET /user/identity` | NEW - from unified intel state |
| Study Archive Stats | Hardcoded `247h`, etc. | `GET /stats/summary` | Same as Home tab |

**Sections in Elite AI Insights:**
- 🚨 Threat Assessment → `intel.threatAssessment`
- ⚡ Weak Points → `intel.weaknesses[]`
- 📈 Predictions → `intel.predictions`
- 🎯 Today's Missions → `intel.todaysMissions[]`
- 💡 Behavioral Insights → `intel.insights`

**ACTION NEEDED:**
- Create `GET /user/identity` endpoint using unified intel state
- Fetch Daily Intel on tab load
- Map backend response to Flutter widgets
- Add refresh button to regenerate

---

### 3. 🎨 **NEURAL CANVAS** (`lib/tabs/canvas_tab.dart`)

**Current:** Shows snackbar on message send (mock)  
**Needs:** Real AI chat integration

**Current Code:**
```dart
onTap: () {
  final text = _inputController.text.trim();
  if (text.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sent: $text')),
    );
  }
}
```

**Needs:**
```dart
// 1. Send to backend
final response = await http.post('/projects/$projectId/message', {
  'message': text,
});

// 2. Add user message to chat
setState(() {
  messages.add({'role': 'user', 'text': text});
});

// 3. Add AI response to chat
setState(() {
  messages.add({'role': 'assistant', 'text': response.reply});
});

// 4. Clear input
_inputController.clear();
```

**ACTION NEEDED:**
- Implement chat message list UI
- Connect to `/projects/:id/message` endpoint
- Add loading state while AI responds
- Store chat history locally
- Add auto-scroll to bottom

---

### 4. 📸 **AI SCANNER** (`lib/screens/ai_scanner_screen.dart`)

**Current:** Shows hardcoded solution after 3 seconds  
**Needs:** Real OCR + AI solving

**Mock Data:**
```dart
final steps = [
  {'step': '1', 'text': 'Subtract 5 from both sides', ...},
  {'step': '2', 'text': 'Simplify', 'equation': '2x = 8'},
  ...
];
```

**Needs:**
```dart
// 1. Capture image (camera/gallery)
final image = await ImagePicker().pickImage(source: ImageSource.camera);

// 2. OCR the image (using Tesseract or cloud OCR)
final ocrText = await performOCR(image);

// 3. Send to backend
final response = await http.post('/scan/solve', {
  'ocrText': ocrText,
  'subject': selectedSubject,
});

// 4. Display solution
setState(() {
  solution = response.solution;
  steps = response.steps;
  topic = response.topic;
});
```

**ACTION NEEDED:**
- Add `image_picker` package
- Integrate OCR library
- Connect to `/scan/solve` endpoint
- Replace mock steps with real AI steps
- Add "Save to Flashcards" functionality

---

### 5. 🎥 **VIDEO MASTERY** (`lib/screens/video_mastery_screen.dart`)

**Current:** Hardcoded concepts + quiz  
**Needs:** Real video AI processing

**Mock Data:**
```dart
final _concepts = [
  {'time': '0:45', 'title': 'Introduction to Photosynthesis', ...},
  {'time': '2:15', 'title': 'Light-Dependent Reactions', ...},
];

final _quizQuestions = [
  {'question': '...', 'options': [...], 'correct': 0},
];
```

**Needs:**
```dart
// 1. Upload video or paste URL
final videoUrl = urlController.text;

// 2. Extract transcript (YouTube API or upload file)
final transcript = await extractTranscript(videoUrl);

// 3. Send to backend
final response = await http.post('/video/summarize', {
  'title': videoTitle,
  'transcript': transcript,
  'url': videoUrl,
});

// 4. Display AI-generated concepts
setState(() {
  concepts = response.concepts;  // With timestamps
  keyPoints = response.keyPoints;
});

// 5. Generate quiz
final quiz = await http.post('/video/generate-quiz', {
  'videoId': response.savedId,
  'conceptIds': selectedConcepts,
});
```

**ACTION NEEDED:**
- Add video URL input
- Integrate YouTube transcript API
- Connect to `/video/summarize` endpoint
- Create `/video/generate-quiz` endpoint
- Replace mock quiz with AI-generated questions

---

### 6. 🃏 **FLASHCARD TURBO** (`lib/screens/flashcard_turbo_screen.dart`)

**Current:** Completely mock (swipeable cards)  
**Needs:** AI-generated flashcards

**Current:** No backend integration at all

**Needs:**
1. **Generate flashcards from:**
   - Scanned problems (`/scan/:id/to-flashcards`)
   - Video summaries (`/video/:id/to-flashcards`)
   - Topics (manual) (`/flashcards/generate`)
   - Past mistakes (`/mastery/weak-topics/to-flashcards`)

2. **Endpoints to create:**
```
POST /flashcards/generate
Body: { topic, subject, count, difficulty }
Returns: { cards: [{ front, back, topic, difficulty }] }

GET /flashcards
Returns: { cards: [...], dueToday: 15, mastered: 42 }

POST /flashcards/:id/review
Body: { quality: 1-5 }  // Spaced repetition
Returns: { nextReview: timestamp }
```

**ACTION NEEDED:**
- Create flashcard generation endpoints
- Implement spaced repetition algorithm
- Connect Flutter to backend
- Add card swipe → review quality tracking

---

### 7. 💡 **DEEP DIVE** (`lib/screens/deep_dive_screen.dart`)

**Current:** Mock knowledge tree  
**Needs:** AI-generated concept dependencies

**Current:** Hardcoded concept nodes

**Needs:**
```
POST /deep-dive/generate-tree
Body: { topic, subject }
Returns: { 
  tree: {
    id, name, description, 
    prerequisites: [id1, id2],
    children: [...]
  },
  lessons: { [id]: { content, quiz } }
}

POST /deep-dive/:nodeId/complete
Body: { quizScore, timeSpent }
Returns: { unlocked: [nodeId3, nodeId4] }
```

**ACTION NEEDED:**
- Create Deep Dive endpoints
- Generate concept dependency graphs
- Create mini-lessons per concept
- Track node completion

---

## 🚀 PRIORITY IMPLEMENTATION ORDER

### **Phase 1: Core Intelligence (Week 1)**
1. ✅ Connect Intel Tab to `/intel/latest`
2. ✅ Connect Home Tab to `/intel/latest`
3. ✅ Create `/stats/summary` endpoint
4. ✅ Create `/user/identity` endpoint using unified intel

### **Phase 2: Chat & Scanner (Week 2)**
5. ✅ Implement Neural Canvas chat UI
6. ✅ Connect to `/projects/:id/message`
7. ✅ Add image picker to Scanner
8. ✅ Connect Scanner to `/scan/solve`
9. ✅ Add OCR integration

### **Phase 3: Video & Flashcards (Week 3)**
10. ✅ Add video URL input
11. ✅ Connect to `/video/summarize`
12. ✅ Create `/video/generate-quiz`
13. ✅ Create flashcard endpoints
14. ✅ Implement spaced repetition

### **Phase 4: Deep Dive (Week 4)**
15. ✅ Create Deep Dive backend
16. ✅ Generate concept trees
17. ✅ Create lesson content
18. ✅ Track progress

---

## 📝 NEW ENDPOINTS TO CREATE

### **1. Stats Summary**
```typescript
GET /stats/summary
Response: {
  totalStudyHours: number,
  peakStreak: number,
  sessionsCompleted: number,
  conceptsMastered: number,
  currentStreak: number,
  weeklyMinutes: number,
  avgSessionLength: number,
}
```

### **2. User Identity**
```typescript
GET /user/identity
Response: {
  archetype: string,
  archetypeIcon: string,
  confidence: number,
  direction: string,
  directionTrend: "up" | "down" | "stable",
  drivers: string[],
  riskTag: string,
  evolutionProgress: number,
}
```

### **3. Flashcard Generation**
```typescript
POST /flashcards/generate
Body: { topic, subject, count, difficulty }

POST /flashcards/:id/review
Body: { quality: 1-5 }

GET /flashcards
GET /flashcards/due-today
```

### **4. Deep Dive**
```typescript
POST /deep-dive/generate-tree
Body: { topic, subject }

GET /deep-dive/:treeId
POST /deep-dive/:nodeId/complete
```

### **5. Quiz Generation**
```typescript
POST /video/:id/generate-quiz
POST /scan/:id/generate-quiz
POST /topics/:topic/generate-quiz
```

---

## 🎯 SUMMARY

**Current State:**
- ✅ Backend has powerful AI (`ai.service.ts`, unified intel)
- ✅ Endpoints exist for chat, scanner, video, intel
- ❌ Flutter uses MOCK DATA everywhere
- ❌ No http calls to backend in most screens

**What We Need:**
1. Connect existing endpoints (Intel, Scanner, Video, Chat)
2. Create missing endpoints (Stats, Identity, Flashcards, Deep Dive, Quiz)
3. Replace all mock data with real API calls
4. Implement loading states and error handling
5. Add offline caching for core features

**Impact:**
Once connected, the app transforms from a beautiful UI demo into a REAL AI-powered study OS! 🔥

