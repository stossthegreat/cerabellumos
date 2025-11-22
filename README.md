# 🧠 CerebellumOS - Elite Study Platform

A **stunning** Flutter study management app with glassmorphic UI, animated backgrounds, and powerful features for students who want to dominate their learning.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.24.0-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

---

## ✨ Features

### 🎯 Study Management
- **Study Targets** - Create exam goals with start/end dates, track progress, mark as complete
- **Today's Missions** - Daily task list with priority levels and efficiency tracking
- **Threat Assessment** - Visual exam countdown with progress predictions

### 🤖 AI Integration (UI Ready)
- Neural chat interface with project-based sessions
- Empty state with smart prompts
- Sidebar project management
- (Backend integration coming soon)

### 📊 Analytics & Insights
- IQ, Power, Mastery, and Streak tracking
- Learning velocity metrics
- Domination roadmap with prioritized tasks
- Critical alerts system

### 🎨 Beautiful UI
- **Glassmorphism** - Frosted glass cards throughout
- **Animated Blobs** - Floating gradient backgrounds
- **Particle Effects** - Dynamic floating particles
- **Smooth Animations** - Page transitions, shimmer effects, scale animations
- **Custom Components** - Reusable gradient buttons, stat cards, mission cards

### ⚙️ Settings & Privacy
- Full settings screen
- Terms of Service
- Privacy Policy
- Data export and management

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Dart 3.0+
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd cerabellumos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📱 Screens Overview

### Onboarding
- 3 stunning pages with animations
- Floating particles
- Pulsing gradients
- Shimmer effects

### Home (Command)
- Power stats (IQ, Power, Mastery, Streak)
- Exam threat assessment
- Today's missions
- Study targets with FAB to add new
- Momentum cards
- Intensity slider

### Study (Power)
- 4 power tools cards:
  - AI Scanner
  - Flashcard Turbo
  - Video Mastery
  - Deep Dive
- Instant Photo Solve

### Neural (Canvas)
- Project-based AI chat sessions
- Sidebar with project list
- Create new projects with emoji picker
- Empty state with smart prompts

### Intel (Teacher)
- Neural analysis engine
- Critical alerts
- Power analysis grid
- Domination roadmap
- Action buttons

---

## 🏗️ Architecture

### State Management
- **Provider** pattern for reactive state
- Three main providers:
  - `AppState` - Global app state
  - `StudyTargetsProvider` - Study targets management
  - `ProjectsProvider` - Projects management

### Data Persistence
- **SharedPreferences** for local storage
- Study targets auto-save
- Projects persist between sessions
- User preferences stored

### Project Structure
```
lib/
├── main.dart                    # App entry point
├── providers/                   # State management
├── screens/                     # Full-screen pages
├── tabs/                        # Bottom tab screens
└── widgets/                     # Reusable components
```

---

## 🎨 Design System

### Colors
- **Violet**: `#8B5CF6` - Primary accent
- **Red**: `#DC2626` - Danger/Critical
- **Pink**: `#EC4899` - Secondary accent
- **Orange**: `#F97316` - Warning
- **Emerald**: `#059669` - Success
- **Cyan**: `#22D3EE` - Info

### Typography
- **Font Weight**: 900 (Black) for headers
- **Letter Spacing**: 2-4px for uppercase text
- **Font**: Inter (via Google Fonts)

### Components
- Glassmorphic cards with backdrop blur
- Gradient buttons with press effects
- Animated background blobs
- Custom scrollbars

---

## 🔧 Configuration

### Customization

**Change app name:**
Edit `pubspec.yaml`:
```yaml
name: cerabellumos
description: Elite Study OS - Beast Mode Learning Platform
```

**Update app icon:**
Replace files in:
- `android/app/src/main/res/`
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**Modify colors:**
All colors are defined as `Color(0xFFHEXCODE)` throughout the codebase.

---

## 🚢 Deployment

### GitHub Actions
Automated APK builds on every push to `main`:

1. Push to main branch
2. GitHub Actions builds release APK
3. APK uploaded as artifact
4. Download from Actions tab

### Manual Release

1. Update version in `pubspec.yaml`
2. Build release APK
3. Test on device
4. Distribute via Play Store / App Store

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0
  lucide_icons: ^0.257.0
  
  # State Management
  provider: ^6.1.1
  
  # Storage
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  
  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.2
```

---

## 🤝 Contributing

This is a private project, but improvements are welcome:

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📄 License

Proprietary - All rights reserved

---

## 🎯 Future Enhancements

- [ ] AI backend integration (Anthropic Claude API)
- [ ] Cloud sync for cross-device support
- [ ] Flashcard system implementation
- [ ] Video note-taking feature
- [ ] Camera scanner for homework
- [ ] Social features (study groups)
- [ ] Advanced analytics dashboard

---

## 📞 Support

For issues or questions:
- Open an issue in GitHub
- Contact via feedback form in app settings

---

## 🏆 Credits

**Converted from React to Flutter**
- Original React prototype provided by user
- Flutter implementation with enhanced features
- Pixel-perfect visual recreation
- Additional features: study targets, onboarding, settings

---

**Built with ❤️ using Flutter**

*Elite students deserve elite tools.* 🚀
