# Companion Asset Requirements

## 📁 Where to Place Your PNG Files

Put your 6 PNG character images in:

```
/home/felix/cerabellumos/assets/companion/
```

## 📋 Required Files (EXACT Names)

You MUST provide these 6 PNG files with **EXACT** file names:

1. `neutral.png` - Default calm state
2. `smile.png` - Happy/positive
3. `closed_eyes.png` - Sleeping/resting
4. `talking_open.png` - Speaking/coaching
5. `worried.png` - Concerned/drift
6. `alert.png` - Urgent/exam stress

## ✅ File Requirements

**Format:** PNG with transparency  
**Size:** Any size (400x400 or larger recommended)  
**Background:** Transparent recommended  
**Position:** Character should be centered in the image  

## 🎨 Character Design Guidelines

- Age: 20s-30s  
- Style: Semi-realistic, professional  
- Vibe: Calm, sharp, study mentor  
- NOT: Childish, cartoonish, chibi  

Each expression should be clearly different but the same character.

## ⚠️ What Happens if Files are Missing?

If a PNG file is missing, the system will:
1. Log an error to the console: `⚠️ Missing companion asset: assets/companion/[filename].png`
2. Try to fallback to `neutral.png`
3. If even `neutral.png` is missing, show a red error icon

## 🧪 Testing Your Images

1. Place all 6 PNG files in `assets/companion/`
2. Run: `flutter pub get` (to refresh assets)
3. Run the app
4. Long-press the companion on the home screen
5. See all 6 expressions in the debug screen

## 🔧 Current State

The system is READY and waiting for your PNG files.  
**NO PLACEHOLDERS** will be generated.  
**NO GUESSING** - only your provided assets will be used.

Once you add the 6 PNG files, the companion will come alive! 🔥

