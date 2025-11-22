# 🚂 RAILWAY ENVIRONMENT VARIABLES

## ✅ REQUIRED (App won't work without these)

### 1. DATABASE_URL
**What:** PostgreSQL database connection string  
**Railway Setup:** When you add a PostgreSQL plugin, Railway auto-sets this  
**Manual format:** `postgresql://user:password@host:port/database`

### 2. OPENAI_API_KEY
**What:** OpenAI API key for GPT-4o (Neural Canvas chat, Daily Intel, Study Nudges)  
**Get it from:** https://platform.openai.com/api-keys  
**Example:** `sk-proj-abc123...`  
**Used for:** Neural Canvas chat, Daily Intel, Study Nudges, all OS intelligence

---

## 🎯 RECOMMENDED (For full features)

### 3. TOGETHER_API_KEY
**What:** Together AI API key for DeepSeek V3 (Quiz generation, Image analysis)  
**Get it from:** https://api.together.xyz/  
**Example:** `abc123...`  
**Used for:** Quiz generation, AI Scanner problem solving, Video→Cards

### 4. GOOGLE_VISION_API_KEY
**What:** Google Cloud Vision API key for OCR  
**Get it from:** https://console.cloud.google.com/  
**Example:** `AIza...`  
**Used for:** AI Scanner OCR (optional - Tesseract is fallback)  
**Note:** If not set, Tesseract OCR will be used instead

---

## ⚙️ OPTIONAL (Advanced/Nice to have)

### 5. OPENAI_MODEL
**What:** Which OpenAI model to use  
**Default:** `gpt-4o`  
**Options:** `gpt-4o`, `gpt-4-turbo`, `gpt-4o-mini`  
**Set to:** `gpt-4o` (recommended) or `gpt-4o-mini` (cheaper)

### 6. TOGETHER_MODEL
**What:** Which Together AI model to use  
**Default:** `deepseek-ai/deepseek-chat`  
**Keep default** unless you want to try other models

### 7. PORT
**What:** Server port  
**Railway auto-sets this** - DON'T MANUALLY SET  
**Default:** `8080`

### 8. HOST
**What:** Server host binding  
**Default:** `0.0.0.0` (auto-set)  
**Don't change this**

### 9. REDIS_URL
**What:** Redis connection for job queues (optional feature)  
**Format:** `redis://user:password@host:port`  
**Only needed if:** You want scheduled jobs (Daily Intel, Study Nudges)  
**Railway Setup:** Add Redis plugin → auto-set

---

## 🔥 OPTIONAL PRO FEATURES (You probably don't need these yet)

### Firebase (Push Notifications)
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=your-client-email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n..."
FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'
```
**Only needed for:** Push notifications to mobile devices

### ElevenLabs (Voice)
```
ELEVENLABS_API_KEY=your-api-key
ELEVENLABS_VOICE_STRICT=voice-id-here
ELEVENLABS_VOICE_BALANCED=voice-id-here
```
**Only needed for:** Voice features (future)

### S3 Storage (Audio files)
```
S3_ENDPOINT=https://s3.amazonaws.com
S3_BUCKET=your-bucket-name
S3_ACCESS_KEY=your-access-key
S3_SECRET_KEY=your-secret-key
```
**Only needed for:** Storing audio files (future)

### Chroma DB (Vector database)
```
CHROMA_URL=http://chroma-host:8000
CHROMA_PATH=/path/to/chroma
CHROMA_COLLECTION_PREFIX=cerabellumos
```
**Only needed for:** Advanced semantic memory (optional)

---

## 📋 RAILWAY SETUP CHECKLIST

### Step 1: Create Railway Project
1. Go to https://railway.app/
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Connect your `cerabellumos` repo

### Step 2: Add PostgreSQL
1. Click "+ New"
2. Select "Database" → "PostgreSQL"
3. Railway auto-sets `DATABASE_URL` ✅

### Step 3: Set Environment Variables
In your Railway project dashboard:

**REQUIRED:**
```
OPENAI_API_KEY=sk-proj-YOUR-KEY-HERE
```

**RECOMMENDED:**
```
TOGETHER_API_KEY=YOUR-TOGETHER-KEY-HERE
GOOGLE_VISION_API_KEY=YOUR-GOOGLE-KEY-HERE
```

**OPTIONAL:**
```
OPENAI_MODEL=gpt-4o
```

### Step 4: Deploy
1. Railway auto-deploys on git push
2. Check logs for errors
3. Run migrations: `npx prisma migrate deploy`

---

## 🎯 MINIMUM VIABLE SETUP (Quick Start)

To get the app working with basic features:

```bash
# In Railway, set ONLY these:
DATABASE_URL=<auto-set by Railway Postgres plugin>
OPENAI_API_KEY=sk-proj-...
```

This gives you:
- ✅ Neural Canvas chat (GPT-4o)
- ✅ Daily Intel
- ✅ Study Nudges
- ✅ Basic stats & identity
- ⚠️ No quiz generation (needs TOGETHER_API_KEY)
- ⚠️ No AI Scanner OCR (falls back to Tesseract)

---

## 🚀 FULL FEATURES SETUP

For everything working:

```bash
DATABASE_URL=<auto-set>
OPENAI_API_KEY=sk-proj-...
TOGETHER_API_KEY=...
GOOGLE_VISION_API_KEY=AIza...
OPENAI_MODEL=gpt-4o
```

This gives you:
- ✅ Everything from minimum setup
- ✅ AI Quiz generation (DeepSeek V3)
- ✅ AI Scanner with Google Vision OCR
- ✅ Video→Cards (DeepSeek V3)
- ✅ Image analysis

---

## 🔍 HOW TO GET API KEYS

### OpenAI (REQUIRED)
1. Go to https://platform.openai.com/api-keys
2. Sign up / Log in
3. Click "Create new secret key"
4. Copy the `sk-proj-...` key
5. Add $5-10 credit (pay-as-you-go)

### Together AI (RECOMMENDED)
1. Go to https://api.together.xyz/
2. Sign up
3. Go to Settings → API Keys
4. Create new key
5. Free tier available!

### Google Vision (OPTIONAL)
1. Go to https://console.cloud.google.com/
2. Create new project
3. Enable "Cloud Vision API"
4. Create credentials → API Key
5. Copy the key
6. Note: Has free tier (1000 requests/month)

---

## 💰 ESTIMATED COSTS

**Monthly for moderate use:**
- Railway: $5/month (Hobby plan) or $0 (trial credits)
- OpenAI: $5-20/month (GPT-4o ~$0.005/1k tokens)
- Together AI: $0-5/month (cheaper than OpenAI)
- Google Vision: $0 (under free tier)

**Total: ~$10-30/month** for full features

---

## 🐛 TROUBLESHOOTING

### "OpenAI API key not found"
- Check you set `OPENAI_API_KEY` (not `OPENAI_KEY`)
- Make sure no spaces before/after the key
- Railway needs rebuild after adding env vars

### "Database connection failed"
- Make sure PostgreSQL plugin is added
- Check `DATABASE_URL` is auto-set
- Try redeploying

### "Module not found" errors
- Railway might not have run `npm install`
- Check build logs
- Try manual redeploy

---

## 📱 CONNECT FLUTTER TO RAILWAY

After Railway deploys, you'll get a URL like:
`https://cerabellumos-production.up.railway.app`

Update Flutter:
```dart
// In lib/services/api_service.dart
static const String baseUrl = 'https://cerabellumos-production.up.railway.app';
```

That's it! Your app now connects to the live backend.

