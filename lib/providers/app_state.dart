import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  int _activeTab = 0;
  bool _focusMode = false;
  double _intensity = 75.0;
  bool _hasSeenOnboarding = false;

  int get activeTab => _activeTab;
  bool get focusMode => _focusMode;
  double get intensity => _intensity;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    _intensity = prefs.getDouble('intensity') ?? 75.0;
    notifyListeners();
  }

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  void toggleFocusMode() {
    _focusMode = !_focusMode;
    notifyListeners();
  }

  void setIntensity(double value) {
    _intensity = value;
    _saveIntensity();
    notifyListeners();
  }

  Future<void> _saveIntensity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('intensity', _intensity);
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    notifyListeners();
  }

  // User data
  final userData = {
    'name': 'Alex',
    'avatar': '🧑‍🎓',
    'streak': 14,
    'xp': 2840,
    'level': 12,
    'totalHours': 127,
    'todayMinutes': 47,
    'weeklyGoal': 10,
    'weeklyDone': 6,
    'iq': 142,
    'studyPower': 8.7,
    'masteryRate': 0.76,
  };

  final exams = [
    {
      'id': 1,
      'subject': 'Chemistry',
      'icon': '⚗️',
      'date': 'Nov 26',
      'days': 5,
      'threat': 'CRITICAL',
      'color': ['#DC2626', '#F97316', '#FACC15'],
      'progress': 62,
      'prediction': '72%'
    },
    {
      'id': 2,
      'subject': 'Biology',
      'icon': '🧬',
      'date': 'Dec 3',
      'days': 12,
      'threat': 'MEDIUM',
      'color': ['#059669', '#14B8A6', '#22D3EE'],
      'progress': 78,
      'prediction': '91%'
    },
    {
      'id': 3,
      'subject': 'Mathematics',
      'icon': '📐',
      'date': 'Dec 8',
      'days': 17,
      'threat': 'HIGH',
      'color': ['#7C3AED', '#A855F7', '#EC4899'],
      'progress': 45,
      'prediction': '58%'
    },
  ];

  final List<Map<String, dynamic>> todayPlan = [];
}

