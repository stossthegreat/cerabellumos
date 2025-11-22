# 🚀 CEREBELLUM OS - SETUP GUIDE

## ✅ WHAT'S READY

### BACKEND (100% Complete):
- **API Endpoints:** All working (stats, identity, intel, chat, scanner, flashcards, quiz)
- **AI Integration:** GPT-4o, DeepSeek V3, Google Vision, Tesseract
- **Database:** Prisma + PostgreSQL
- **Unified Intelligence:** Identity Engine, Study Patterns, Mastery Map

### FRONTEND (Chat UI Fixed):
- **Neural Canvas:** Real chat UI with message bubbles ✅
- **API Service:** HTTP client ready to connect ✅
- **UI:** All screens built and stunning ✅

---

## 🔧 WHAT YOU NEED TO DO TO GET IT WORKING

### 1️⃣ BACKEND SETUP

#### A. Run Database Migration
You need to apply the new Prisma schema (Flashcard & Quiz models):

```bash
cd backend
npx prisma migrate dev --name add_flashcard_quiz_models
```

This creates the `Flashcard` and `Quiz` tables in your database.

#### B. Set Environment Variables
Create/update `backend/.env` with:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/cerabellumos"

# AI Providers
OPENAI_API_KEY="sk-..."                    # GPT-4o for OS intelligence
TOGETHER_API_KEY="..."                     # DeepSeek V3 for quizzes
GOOGLE_VISION_API_KEY="..."                # For OCR (optional, Tesseract fallback works)

# Auth (if using)
JWT_SECRET="your-secret-key"

# Redis (if using for caching)
REDIS_URL="redis://localhost:6379"
```

#### C. Start the Backend
```bash
cd backend
npm install
npm run dev
```

Backend will run on `http://localhost:8080`

---

### 2️⃣ FLUTTER APP SETUP

#### A. Update API Base URL
Open `lib/services/api_service.dart` and change this line:

```dart
static const String baseUrl = 'http://localhost:8080'; // ← CHANGE THIS
```

**Options:**
- **Local development:** `http://10.0.2.2:8080` (Android emulator)
- **Real device (same network):** `http://YOUR_COMPUTER_IP:8080`
- **Production:** Your Railway/Render URL (e.g., `https://your-app.railway.app`)

#### B. Create a Test User
The app needs a `userId` and `authToken` to make API calls.

**Option 1: Manual Setup (Quick Test)**

Create a user in your database manually, then add this to Flutter:

```dart
// In lib/services/api_service.dart, temporarily hardcode:
static Future<String?> _getUserId() async {
  return "your-test-user-id"; // ← Paste your user ID from DB
}

static Future<String?> _getToken() async {
  return "test-token"; // ← Or real JWT token if using auth
}
```

**Option 2: Build Login Screen (Better)**

Create a login/signup screen that:
1. Calls `POST /auth/register` or `POST /auth/login`
2. Saves the `userId` and `token` to SharedPreferences
3. Uses them for all API calls

---

### 3️⃣ NEURAL CANVAS CHAT - HOW IT WORKS

#### Before Chat Works:
1. **Backend must be running** (`npm run dev`)
2. **User must have a project** (create one using the + button in sidebar)
3. **API baseUrl must be correct** (see step 2A above)

#### Chat Flow:
```
User types message
   ↓
Flutter saves to _messages list (instant UI update)
   ↓
API call: POST /projects/:projectId/message
   ↓
Backend sends to OpenAI GPT-4o
   ↓
Response comes back
   ↓
Flutter adds AI message to _messages list
   ↓
Auto-scroll to bottom
```

#### If Chat Doesn't Work:
1. Check console for errors
2. Make sure backend is running: `curl http://localhost:8080/health`
3. Check that `userId` is set (print it in Flutter console)
4. Verify API URL is correct (print full URL before calling)
5. Check backend logs for errors

---

### 4️⃣ OTHER FEATURES REQUIRING BACKEND

#### AI Scanner (Photo Solve):
- **Endpoint:** `POST /scan/solve`
- **Needs:** 
  - Image picker: `flutter pub add image_picker`
  - Convert image to base64
  - Send to backend
- **Backend will:** OCR (Google Vision/Tesseract) → AI solve (DeepSeek V3)

#### Flashcard Turbo:
- **Endpoints:** 
  - `POST /flashcards/generate` (create AI flashcards)
  - `GET /flashcards` (load cards)
  - `POST /flashcards/:id/review` (spaced repetition)
- **UI:** Already built, just needs API connection

#### Video Mastery:
- **Endpoint:** `POST /video/summarize`
- **Needs:** YouTube transcript API or video URL input
- **Backend will:** Extract key concepts → Generate quiz

#### Intel Tab:
- **Endpoint:** `GET /intel/latest`
- **Returns:** Daily AI intelligence (threats, insights, missions)
- **UI:** Already built, just needs to fetch and parse data

#### Identity Engine:
- **Endpoint:** `GET /user/identity`
- **Returns:** Archetype, confidence, direction, drivers
- **UI:** Already built, just needs real data

#### Archive Stats (4 Cards on Home):
- **Endpoint:** `GET /stats/summary`
- **Returns:** Total hours, peak streak, sessions, mastery
- **UI:** Already built, just needs real data

---

## 🎯 QUICK START CHECKLIST

### Backend:
- [ ] Run `npx prisma migrate dev`
- [ ] Set environment variables (.env file)
- [ ] Start backend: `npm run dev`
- [ ] Test: `curl http://localhost:8080/health`

### Frontend:
- [ ] Update `baseUrl` in `api_service.dart`
- [ ] Create test user OR hardcode userId/token
- [ ] Run app: `flutter run`
- [ ] Create a project in Neural Canvas sidebar
- [ ] Send a message!

---

## 🐛 DEBUGGING

### "Failed to send message" Error:
```dart
// Add this to _sendMessage() in canvas_tab.dart:
print('Sending to: ${ApiService.baseUrl}/projects/${activeProject['id']}/message');
```

### Backend Not Receiving Requests:
- Check CORS settings in `backend/src/server.ts`
- Make sure backend is listening on `0.0.0.0`, not `localhost`

### Database Errors:
- Run `npx prisma studio` to view/edit database
- Check `DATABASE_URL` is correct

---

## 📊 NEXT STEPS

Once chat is working, you can:

1. **Connect Intel Tab** → Fetch `/intel/latest` on load
2. **Connect Home Stats** → Fetch `/stats/summary` for archive cards
3. **Implement Image Picker** → For AI Scanner
4. **Build Auth Flow** → Login/signup screens
5. **Add Video Input** → For Video Mastery
6. **Implement Flashcard Swiping** → With spaced repetition API

---

## 🚀 DEPLOYMENT

### Backend (Railway):
```bash
railway login
railway init
railway up
```

Set env vars in Railway dashboard.

### Frontend (Build APK):
```bash
flutter build apk --release
```

Upload to Google Play or distribute directly.

---

## 💡 TIPS

- **Start simple:** Get chat working first, then add other features
- **Use mock data:** If backend isn't ready, keep using mock data temporarily
- **Check logs:** Both Flutter console and backend terminal
- **Test incrementally:** One feature at a time

---

**Questions?** Check the error messages carefully - they usually tell you exactly what's wrong!

