# 🚂 UPDATE RAILWAY URL - QUICK GUIDE

## 📍 STEP 1: GET YOUR RAILWAY URL

1. Go to https://railway.app/
2. Click on your `cerabellumos` backend project
3. Look for **"Settings"** tab or **"Deployments"**
4. Find the URL - it looks like:
   - `https://cerabellumos-production.up.railway.app`
   - OR `https://something-random.railway.app`
   
**Copy that full URL!** ⬆️

---

## ⚡ STEP 2: UPDATE FLUTTER

Open this file:
```
lib/services/api_service.dart
```

**Find line 11:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

**Change it to:**
```dart
static const String baseUrl = 'https://your-railway-url-here.railway.app';
```

**Example:**
```dart
static const String baseUrl = 'https://cerabellumos-production.up.railway.app';
```

⚠️ **IMPORTANT:**
- Use `https://` (not `http://`)
- NO trailing slash at the end
- Copy the EXACT URL from Railway

---

## 🔥 STEP 3: REBUILD APP

```bash
flutter clean
flutter pub get
flutter run
```

**OR** just hot restart (R key in terminal)

---

## ✅ DONE!

Now your app connects to Railway backend! 🚀

Neural Canvas should work from anywhere (not just when connected to your computer).

---

## 🐛 IF IT STILL DOESN'S WORK:

1. **Check Railway logs:**
   - Go to Railway dashboard → Your project → Logs
   - Look for errors when you send a message

2. **Test Railway backend directly:**
   ```bash
   curl https://your-url.railway.app/health
   ```
   Should return `{"ok": true}`

3. **Check environment variables:**
   - Make sure `OPENAI_API_KEY` is set in Railway
   - Check `DATABASE_URL` is set

4. **Common issues:**
   - Railway app crashed? Check logs
   - Database not migrated? Run migrations
   - No API key? Set `OPENAI_API_KEY` in Railway variables

---

## 💡 PRO TIP:

You can switch between local and Railway easily:

```dart
// lib/services/api_service.dart

// For local testing:
// static const String baseUrl = 'http://10.0.2.2:8080';

// For production (Railway):
static const String baseUrl = 'https://your-app.railway.app';
```

Just comment/uncomment the one you need!

