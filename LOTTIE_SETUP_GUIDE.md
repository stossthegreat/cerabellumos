# 🎨 Lottie Mascot Setup Guide

## 📥 STEP 1: Download Your Lottie Mascot

Go to **LottieFiles.com** and download your mascot animation.

**Recommended searches:**
- "study mascot"
- "cute robot"
- "smart owl"
- "brain character"
- "education mascot"

**Download format:** JSON file

---

## 📂 STEP 2: File Structure

You'll need **4 different Lottie files** for different emotional states:

```
assets/lottie/
├── mascot_idle.json        ← Main idle/neutral animation
├── mascot_happy.json       ← Celebrating/achievement animation
├── mascot_serious.json     ← Focused/alert animation
├── mascot_sleeping.json    ← Sleeping/resting animation
└── mascot_talking.json     ← Talking/speaking animation (OPTIONAL)
```

---

## 🎯 OPTION A: Single Lottie File (Simplest)

If you only have **ONE** Lottie file, just use it for everything:

1. Download your mascot from LottieFiles
2. Save it as `mascot_idle.json`
3. Copy it 4 times:
   ```bash
   cp assets/lottie/mascot_idle.json assets/lottie/mascot_happy.json
   cp assets/lottie/mascot_idle.json assets/lottie/mascot_serious.json
   cp assets/lottie/mascot_idle.json assets/lottie/mascot_sleeping.json
   cp assets/lottie/mascot_idle.json assets/lottie/mascot_talking.json
   ```

**Result:** Same animation for all states (still works!)

---

## 🎯 OPTION B: Multiple Variations (Best)

If you want different animations for different moods:

1. Download 4-5 different variations of your mascot
2. Rename them to match the emotional states
3. Put them in `assets/lottie/`

**Example:**
- **Idle:** Gentle breathing/blinking animation
- **Happy:** Jumping/celebrating animation
- **Serious:** Focused/concentrated pose
- **Sleeping:** Zzz/resting animation
- **Talking:** Mouth moving/head bobbing

---

## 🔧 STEP 3: Update Code (AUTOMATIC)

The system is already set up! Just add your files to `assets/lottie/` and they'll work automatically.

**File mapping:**
```dart
// EMOTION ENGINE → LOTTIE FILE

// Smile states → mascot_happy.json
smile_soft, smile_big, smile_confident

// Serious states → mascot_serious.json
serious_1, serious_2

// Sleeping states → mascot_sleeping.json
eyes_closed_1, eyes_closed_2, eyes_closed_soft

// Talking → mascot_talking.json
When voice is playing

// Default → mascot_idle.json
neutral_default, all other states
```

---

## 🎤 STEP 4: Voice Sync (Optional)

**If you have a "talking" animation:**
- The mascot will automatically switch to `mascot_talking.json` when voice plays
- Animation loops while speaking
- Returns to emotional state when done

**If you DON'T have a talking animation:**
- Just use your main idle animation
- It will still loop during voice playback

---

## 🧪 TESTING

### Test 1: Check if Lottie loads
1. Run the app
2. Go to Home tab
3. Mascot should appear (if files exist)
4. If you see a blue smiley icon = Lottie file missing

### Test 2: Test emotions
1. Study for 30 mins → Should show happy animation
2. Add exam 2 days away → Should show serious animation
3. Wait until night → Should show sleeping animation

### Test 3: Test talking
1. Long-press mascot → Debug screen
2. Tap "Start Talking" button
3. Mascot should switch to talking animation

---

## ❌ TROUBLESHOOTING

### "Failed to load Lottie" error
**Problem:** Lottie file missing or wrong path

**Fix:**
1. Check file exists: `assets/lottie/mascot_idle.json`
2. Check `pubspec.yaml` includes `assets/lottie/`
3. Run `flutter pub get`
4. Restart app

### Mascot shows blue icon instead
**Problem:** Lottie file not found

**Fix:**
- Fallback icon appears when Lottie file missing
- Add at least `mascot_idle.json` to show something

### Animation doesn't change
**Problem:** All files are the same

**Solution:** This is OK! System works with one file.
- Companion still reacts to emotions (same animation)
- Voice sync still works

---

## 📦 RECOMMENDED LOTTIE FILES

Search these on LottieFiles.com:

1. **"cute robot mascot"** - Tech vibe, professional
2. **"owl study"** - Classic study companion
3. **"brain thinking"** - Perfect for Study OS
4. **"student learning"** - Educational theme
5. **"AI assistant"** - Futuristic vibe

**Download as JSON**, rename to match our structure!

---

## 🔥 QUICK START (1 FILE ONLY)

**Fastest way to get started:**

1. Download ANY cute Lottie mascot from LottieFiles
2. Save it as `mascot_idle.json` in `assets/lottie/`
3. Run this in terminal:
   ```bash
   cd assets/lottie
   cp mascot_idle.json mascot_happy.json
   cp mascot_idle.json mascot_serious.json
   cp mascot_idle.json mascot_sleeping.json
   cp mascot_idle.json mascot_talking.json
   ```
4. Run `flutter pub get`
5. Run app

**DONE! Mascot appears!** 🎉

Later, you can replace individual files with different animations.

---

## 🎨 ADVANCED: Custom Animation Speed

**If you want to control speed:**

Edit `lib/companion/lottie_companion_widget.dart`:

```dart
Lottie.asset(
  _getLottieFile(),
  controller: _controller,
  animate: !widget.isTalking,
  repeat: true,
  
  // Add this:
  frameRate: FrameRate(60), // Smooth 60fps
  
  // Or control speed:
  options: LottieOptions(
    enableMergePaths: true,
  ),
)
```

---

## 🚀 THAT'S IT!

Your Lottie mascot will:
- ✅ React to your study progress
- ✅ Change based on emotions (if you have multiple files)
- ✅ Sync with voice when speaking
- ✅ Loop smoothly
- ✅ Look professional and clean

**The emotion engine is ALREADY connected!**

Just add your Lottie files and GO! 🔥

