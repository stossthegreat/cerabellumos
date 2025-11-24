import 'dart:math';
import 'companion_state.dart';

/// The brain of the companion - analyzes app state and determines emotion
class CompanionEmotionEngine {
  /// Analyzes the user's current study state and returns the appropriate emotion
  /// 
  /// Priority order:
  /// 1. Time-based (sleeping if 22:00-6:00)
  /// 2. Exam proximity (alert if < 5 days)
  /// 3. Today's progress (proud if met goal, disappointed if 0)
  /// 4. Streak (focused if on streak)
  /// 5. Default: idle or curious
  static CompanionEmotionData analyze({
    required int streak,
    required int todayMinutes,
    required List<dynamic> exams,
    required int hour,
    required List<dynamic> targets,
  }) {
    // 1. Time-based: Sleeping during night hours
    if (hour >= 22 || hour < 6) {
      return CompanionEmotionData(
        state: CompanionState.sleeping,
        reason: _getSleepMessage(hour),
        intensity: 0.3,
      );
    }

    // 2. Exam proximity: Alert if exam is very close
    final criticalExam = _findCriticalExam(exams);
    if (criticalExam != null) {
      final days = criticalExam['days'] as int;
      return CompanionEmotionData(
        state: CompanionState.alert,
        reason: '${criticalExam['subject']} exam in $days days!',
        intensity: days <= 2 ? 1.0 : 0.7,
      );
    }

    // 3. Today's progress: Proud if user hit their goal
    if (todayMinutes >= 60) {
      return CompanionEmotionData(
        state: CompanionState.proud,
        reason: 'You\'re crushing it today! ${todayMinutes} minutes studied',
        intensity: min(todayMinutes / 120, 1.0),
      );
    }

    // 4. Disappointment: Late in the day with no progress
    if (hour >= 18 && todayMinutes == 0) {
      return CompanionEmotionData(
        state: CompanionState.disappointed,
        reason: 'Haven\'t started studying yet today...',
        intensity: 0.6,
      );
    }

    // 5. Focused: Active streak and some progress today
    if (streak > 3 && todayMinutes > 0) {
      return CompanionEmotionData(
        state: CompanionState.focused,
        reason: '$streak day streak! Keep the momentum going',
        intensity: 0.8,
      );
    }

    // 6. Curious: Random variation (20% chance)
    if (Random().nextDouble() < 0.2) {
      return CompanionEmotionData(
        state: CompanionState.curious,
        reason: _getCuriousMessage(),
        intensity: 0.7,
      );
    }

    // 7. Default: Idle (calm, ready to help)
    return CompanionEmotionData(
      state: CompanionState.idle,
      reason: 'Ready to learn together',
      intensity: 0.5,
    );
  }

  /// Find the most critical exam (closest one within 5 days)
  static Map<String, dynamic>? _findCriticalExam(List<dynamic> exams) {
    for (final exam in exams) {
      final days = exam['days'] as int;
      if (days <= 5) {
        return exam as Map<String, dynamic>;
      }
    }
    return null;
  }

  /// Get a sleep message based on hour
  static String _getSleepMessage(int hour) {
    if (hour >= 22 && hour < 24) {
      return 'Resting for tomorrow\'s focus';
    } else if (hour >= 0 && hour < 3) {
      return 'Deep sleep mode...';
    } else {
      return 'Still dreaming...';
    }
  }

  /// Get a random curious message
  static String _getCuriousMessage() {
    final messages = [
      'What should we learn today?',
      'Ready for a challenge?',
      'Let\'s explore something new',
      'Wondering what you\'re working on...',
      'Time for a study session?',
    ];
    return messages[Random().nextInt(messages.length)];
  }
}

