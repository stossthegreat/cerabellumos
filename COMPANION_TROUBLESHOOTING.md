# 🔧 Companion Troubleshooting Guide

## ✅ WHAT SHOULD HAPPEN AUTOMATICALLY:

### **1. AUTO-BLINKING (Works Immediately, No Setup Required)**

**What you should see:**
- Companion blinks every 2-4 seconds
- Smooth animation through eye states
- Continuous loop (never stops)

**Console logs:**
```
👁️ Companion controller initialized - starting auto-blink
👁️ Next blink scheduled in 3 seconds
👁️ Performing blink animation
👁️ Blink complete, back to neutral_default
👁️ Next blink scheduled in 2 seconds
```

**If NOT blinking:**
1. Check console for `👁️` logs
2. Go to debug screen (long-press companion)
3. Look for green "Auto-Blink" badge
4. If no logs → controller not initializing

---

### **2. WELCOME MESSAGE (On App Open)**

**What you should see:**
- 2 seconds after opening app
- Companion mouth starts moving
- Text appears in console
- (Voice plays if Eleven Labs configured)

**Console logs:**
```
🎤 Attempting to play welcome message...
🎤 Fetching welcome message from backend...
✅ Welcome message received: Morning champion...
🎤 Audio present: true (or false)
🎤 Playing voice message with audio...
✅ Welcome message complete
```

**If NOT working:**
- Check console for errors
- Verify backend is online: https://cerabellumos-production.up.railway.app/health
- If backend offline → shows default welcome animation

---

## 🎤 VOICE SETUP (Required for Audio):

### **Current Status:**
Voice will NOT work until you add Eleven Labs credentials to Railway.

### **How to Enable Voice:**

1. **Get Eleven Labs API Key:**
   - Go to https://elevenlabs.io/
   - Sign up / Log in
   - Profile → API Keys → Copy

2. **Get Voice ID:**
   - VoiceLab → Pick a voice
   - Click voice → Copy Voice ID

3. **Add to Railway:**
   ```
   ELEVENLABS_API_KEY=sk_abc123...
   ELEVENLABS_VOICE_ID=21m00Tcm4TlvDq8ikWAM
   ```

4. **Redeploy backend** (automatic on push)

5. **Test:**
   ```bash
   curl https://cerabellumos-production.up.railway.app/api/companion/welcome \
     -H "x-user-id: test-user-123"
   ```

   Should return:
   ```json
   {
     "text": "Morning champion. Ready to dominate today?",
     "emotion": "encouraging",
     "audioBase64": "//uQx..." (if Eleven Labs configured),
     "timestamp": "2025-11-25T..."
   }
   ```

---

## 🧪 TESTING CHECKLIST:

### **Test 1: Blinking (Should work NOW)**
- [ ] Open app
- [ ] Go to home tab
- [ ] Watch companion for 5 seconds
- [ ] Should see blink animation (eyes close & open)
- [ ] Check console for `👁️` logs

**Expected:**
```
👁️ Next blink scheduled in 2 seconds
👁️ Performing blink animation
👁️ Blink complete
```

### **Test 2: Debug Screen**
- [ ] Long-press companion
- [ ] See grid of all 18 states
- [ ] Green "Auto-Blink" badge visible
- [ ] Tap volume icon
- [ ] Mouth should cycle (A/E/O shapes)

**Expected:**
```
🎤 Companion started talking
🎤 Companion stopped talking
```

### **Test 3: Welcome Message (Animation)**
- [ ] Close app completely
- [ ] Reopen app
- [ ] Wait 2-3 seconds
- [ ] Companion mouth should move
- [ ] Check console

**Expected (WITHOUT Eleven Labs):**
```
🎤 Attempting to play welcome message...
🎤 Fetching from backend...
✅ Welcome message received
🎤 Audio present: false
🎤 Eleven Labs not configured - showing animation only
```

**Expected (WITH Eleven Labs):**
```
🎤 Attempting to play welcome message...
🎤 Fetching from backend...
✅ Welcome message received
🎤 Audio present: true
🎤 Playing voice message with audio...
🎤 Playing voice message: "Morning champion..."
✅ Voice message playback complete
```

### **Test 4: Backend Health**
```bash
curl https://cerabellumos-production.up.railway.app/health
```

Should return:
```json
{
  "status": "ok",
  "timestamp": "...",
  "services": { ... }
}
```

---

## 🚨 COMMON ISSUES:

### **Issue: Companion NOT blinking**

**Symptoms:**
- Companion just sits there, frozen
- No `👁️` logs in console

**Fixes:**
1. Check if CompanionController is in providers (main.dart):
   ```dart
   ChangeNotifierProvider(create: (_) => CompanionController()),
   ```
2. Hot restart app (not hot reload)
3. Check console for init message
4. Long-press companion → check "Auto-Blink" badge

---

### **Issue: Welcome message NOT playing**

**Symptoms:**
- No mouth animation on app open
- No `🎤` logs in console

**Fixes:**
1. Check console for error messages
2. Verify you're on home tab when app opens
3. Try closing app completely and reopening
4. Check backend logs on Railway
5. Verify route: `/api/companion/welcome` exists

**Manual test:**
```bash
# Should return welcome message (text at minimum)
curl https://cerabellumos-production.up.railway.app/api/companion/welcome \
  -H "x-user-id: test-user-123"
```

---

### **Issue: Voice NOT playing (only animation)**

**This is NORMAL if Eleven Labs not configured!**

**Symptoms:**
- Mouth moves (talking animation) ✅
- No sound from speakers ⚠️
- Console: `🎤 Audio present: false`

**This means:**
- Backend is working ✅
- Animation is working ✅
- Voice service not configured ⚠️

**To enable voice:**
Add to Railway environment variables:
```
ELEVENLABS_API_KEY=your_key
ELEVENLABS_VOICE_ID=your_voice_id
```

**After adding:**
- Redeploy backend
- Reopen app
- Console should show: `🎤 Audio present: true`
- Speakers should play voice

---

### **Issue: Build errors**

**Error:** `The getter 'content' isn't defined`

**Fix:** Already fixed in latest commit
- CoachingMessage now has audioBase64 field
- Pull latest code: `git pull`

---

## 📊 WHAT'S WORKING RIGHT NOW:

### ✅ **Working (No Setup Required):**
- 18-state companion avatar system
- Auto-blinking animation (every 2-4 sec)
- Talking animation (mouth shapes)
- Debug screen (all states visible)
- Welcome message (animation only)
- Coaching message (animation only)

### ⚠️ **Requires Setup (Eleven Labs):**
- Voice audio playback
- Personalized TTS
- Emotion-based voice tones

---

## 🎯 EXPECTED BEHAVIOR:

### **On App Open:**
```
1. App loads
2. CompanionController initializes
   → Console: "👁️ Companion controller initialized"
3. After 2 seconds:
   → Console: "👁️ Next blink scheduled in X seconds"
4. After 2-4 more seconds:
   → Companion blinks (eyes close/open)
   → Console: "👁️ Performing blink animation"
5. After 2 seconds (first time today):
   → Console: "🎤 Attempting to play welcome message..."
   → Companion mouth moves (talking animation)
   → (Voice plays if Eleven Labs configured)
6. Blinking resumes after welcome
7. Cycle continues forever
```

---

## 🔥 DIAGNOSTIC COMMANDS:

### **Check backend status:**
```bash
curl https://cerabellumos-production.up.railway.app/health
```

### **Test welcome endpoint:**
```bash
curl https://cerabellumos-production.up.railway.app/api/companion/welcome \
  -H "x-user-id: test-user-123"
```

### **Test TTS directly:**
```bash
curl -X POST https://cerabellumos-production.up.railway.app/api/companion/speak \
  -H "Content-Type: application/json" \
  -H "x-user-id: test-user-123" \
  -d '{"text":"This is a test","emotion":"calm"}'
```

---

## 📱 FLUTTER CONSOLE COMMANDS:

```bash
# See all companion logs
flutter run | grep -E '👁️|🎤'

# Full debug output
flutter run --verbose
```

---

## 🚀 NEXT STEPS:

1. **Run app and check console** for `👁️` logs
2. **Watch companion for 5 seconds** (should blink)
3. **Close & reopen app** (should see welcome animation)
4. **Add Eleven Labs to Railway** (for voice)
5. **Test again** (should hear voice + see mouth move)

---

## 💡 QUICK FIX:

**If nothing is working:**

1. **Stop app**
2. **Run:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Watch console carefully** for all `👁️` and `🎤` logs
4. **Share console output** if still not working

---

## 🎯 SUMMARY:

**What works NOW:**
- ✅ Auto-blinking (every 2-4 sec)
- ✅ Welcome animation (mouth moves)
- ✅ Talking animation (debug screen)
- ✅ All 18 states loaded

**What needs Eleven Labs:**
- ⚠️ Voice audio playback
- ⚠️ Actual speech from speakers

**The companion IS working - just no sound yet!**

Add Eleven Labs keys → Companion talks with voice! 🎤🔥

