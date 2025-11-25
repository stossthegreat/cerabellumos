# 🎯 Companion State Guide - When Each Expression Appears

## 18 States Mapped to Study OS Intelligence

---

## 😐 NEUTRAL/DEFAULT STATES

### **neutral_default** (Default idle state)
**When it appears:**
- Morning (6-11am), no study yet
- Afternoon (12-5pm), no targets
- Evening (5-10pm), ready to study
- Default idle state

**Triggers:**
- No exams within 7 days
- No urgent deadlines
- No drift detected
- Neutral app state

**Message examples:**
- "Ready when you are. Let's dominate."
- "Your brain is sharpest now. Make it count."
- "Evening window. This is your power hour."

---

## 😊 SMILE STATES (Achievements & Progress)

### **smile_soft** (Gentle encouragement)
**When it appears:**
- Studied 1-60 minutes today
- Building momentum
- Fresh start

**Triggers:**
- `todayMinutes >= 1 && todayMinutes < 60`

**Message examples:**
- "Good start. Build that momentum."
- "Just getting started. Let's go."

### **smile_big** (Happy with progress)
**When it appears:**
- Studied 60+ minutes
- Strong session completed
- Good streak (not elite yet)

**Triggers:**
- `todayMinutes >= 60 && todayMinutes < 90`
- OR `todayMinutes >= 60 && streak < 14`

**Message examples:**
- "60 minutes of focused work. Keep it up!"
- "75 mins • 5-day streak • Strong work!"

### **smile_confident** (Elite performance)
**When it appears:**
- Studied 90+ minutes
- High streak (7-14+ days)
- Absolute domination

**Triggers:**
- `todayMinutes >= 90 && streak >= 7`
- Peak performance detected

**Message examples:**
- "90 mins • 14-day streak • ELITE LEVEL!"
- "120 minutes today! Crushing it!"

---

## 😴 EYES CLOSED STATES (Sleep, Rest, Disappointment)

### **eyes_closed_1** (Light sleep / Drift concern)
**When it appears:**
- Night hours (10pm-6am), no study
- Early drift detection
- Low activity warning

**Triggers:**
- `hour >= 22 || hour <= 5`
- `todayMinutes == 0 && streak < 3`

**Message examples:**
- "Night mode. See you tomorrow."
- "No study yet today. Keep that consistency."

### **eyes_closed_2** (Disappointed / Serious concern)
**When it appears:**
- Evening (6pm+), zero study
- Streak at risk (7+ days)
- Drift alert

**Triggers:**
- `todayMinutes == 0 && hour >= 18 && streak >= 3`

**Message examples:**
- "7-day streak at risk. Don't break it now."
- "No study today. Your streak needs you."

### **eyes_closed_soft** (Peaceful rest / Well-earned)
**When it appears:**
- Night hours after good day
- Rest mode (studied 60+ mins)
- Peaceful sleep

**Triggers:**
- `(hour >= 22 || hour <= 5) && todayMinutes >= 60`

**Message examples:**
- "Day well spent. Rest and recover."
- "90 minutes today. Sleep well, champion."

---

## 😠 SERIOUS STATES (Focus, Urgency, Stress)

### **serious_1** (Focused / Alert / Preparing)
**When it appears:**
- Exam within 3-7 days
- Urgent deadlines (targets due soon)
- Need to lock in

**Triggers:**
- Exam `daysRemaining <= 7 && >= 3`
- Urgent targets (deadline ≤ 3 days)
- Evening hours + no study + targets pending

**Message examples:**
- "5 days until Biology. Stay sharp."
- "Deadlines approaching. Lock in time."
- "Chemistry exam coming. Focus mode activated."

### **serious_2** (ULTRA SERIOUS / Exam crisis)
**When it appears:**
- Exam tomorrow or today
- Final push mode
- Maximum urgency

**Triggers:**
- Exam `daysRemaining <= 2`
- Critical exam window

**Message examples:**
- "Biology exam TODAY. Final push."
- "Exam tomorrow. Review mode."
- "Physics in 2 days. Lock in."

---

## 🗣️ MOUTH STATES (TALKING ANIMATION ONLY)

### **mouth_A_1, mouth_A_2, mouth_A_3, mouth_A_4**
**When they appear:**
- ONLY during talking animation
- Cycles automatically when voice plays
- Part of A/E/O speech pattern

**Triggers:**
- `controller.startTalking()` called
- Voice message playing
- Manual talking test

### **mouth_O_1, mouth_O_2**
**When they appear:**
- ONLY during talking animation
- Part of speech cycle

### **mouth_E_1, mouth_E_2, mouth_E_3**
**When they appear:**
- ONLY during talking animation
- Part of speech cycle

**Talking sequence:**
```
A1 → A2 → E1 → E2 → O1 → O2 → A3 → E3 → A4 → repeat
120ms per frame
```

---

## 📊 STATE PRIORITY SYSTEM:

The emotion engine evaluates conditions in this order:

1. **Exam Crisis** (≤ 2 days) → `serious_2`
2. **Exam Prep** (3-7 days) → `serious_1`
3. **Deadline Stress** → `serious_1`
4. **Drift Alert** (streak at risk) → `eyes_closed_1` or `eyes_closed_2`
5. **Elite Performance** (90+ mins, high streak) → `smile_confident`
6. **Strong Session** (60+ mins) → `smile_big`
7. **Good Start** (25-60 mins) → `smile_soft`
8. **Fresh Start** (1-25 mins) → `smile_soft`
9. **Sleeping** (night hours) → `eyes_closed_1` or `eyes_closed_soft`
10. **Morning Energy** → `neutral_default`
11. **Default** → `neutral_default`

---

## 🎯 EXAMPLE SCENARIOS:

### **Scenario 1: Normal Study Day**
```
8am: neutral_default ("Morning. Your brain is sharpest now")
9am: Started studying
10am (30 mins): smile_soft ("Good start. Build momentum")
12pm (90 mins): smile_big ("90 minutes! Strong work!")
10pm: eyes_closed_soft ("Day well spent. Rest well")
```

### **Scenario 2: Exam Week**
```
Monday (7 days): serious_1 ("7 days until Chemistry. Stay sharp")
Wednesday (5 days): serious_1 ("5 days. Lock in mode")
Friday (3 days): serious_1 ("3 days. Final prep time")
Saturday (2 days): serious_2 ("2 days. Ultra focus mode")
Sunday (1 day): serious_2 ("Exam tomorrow. Review everything")
Monday (exam day): serious_2 ("Chemistry TODAY. You got this")
```

### **Scenario 3: Drift Recovery**
```
Monday: smile_big (studied 75 mins)
Tuesday: smile_soft (studied 30 mins)
Wednesday: neutral_default (0 mins, morning)
Wednesday 7pm: eyes_closed_2 ("7-day streak at risk!")
Thursday: smile_soft (recovered, 40 mins)
```

### **Scenario 4: Elite Performance**
```
Day 14 streak, 120 mins studied:
→ smile_confident ("120 mins • 14-day streak • ELITE LEVEL!")
```

---

## 🧪 HOW TO TRIGGER EACH STATE (For Testing):

### **Test smile_soft:**
- Study for 30 minutes
- Companion should switch to soft smile

### **Test smile_big:**
- Study for 70 minutes
- Companion should show big smile

### **Test smile_confident:**
- Get 14-day streak + study 90+ mins
- Companion shows confident smile

### **Test serious_1:**
- Create exam 5 days away
- Companion shows serious expression

### **Test serious_2:**
- Create exam tomorrow
- Companion shows ultra-serious expression

### **Test eyes_closed_1:**
- Set time to 11pm (or wait until night)
- Companion shows sleeping state

### **Test eyes_closed_2:**
- Have 7+ day streak
- Don't study all day
- Check at 7pm
- Companion shows disappointed

### **Test mouth states:**
- Long-press companion → debug screen
- Tap volume icon
- Mouth cycles through all A/E/O shapes

---

## 🔥 THE RESULT:

**Your companion now REACTS to:**
- ✅ Exam deadlines (7 days → urgent → tomorrow → today)
- ✅ Study minutes (0 → 25 → 60 → 90+)
- ✅ Streak status (low → medium → high → elite)
- ✅ Time of day (morning/afternoon/evening/night)
- ✅ Drift detection (streak at risk)
- ✅ Target deadlines (urgent tasks)
- ✅ Performance level (good → strong → elite)

**18 states used contextually, not randomly!**

**This is INTELLIGENT, not just blinking!** 🧠🔥

