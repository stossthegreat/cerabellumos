import 'companion_state.dart';
import '../models/study_target.dart';

/// Companion Emotion Engine
/// 
/// Maps Study OS intelligence data → companion facial expressions
/// Uses all 18 states contextually based on what's happening in the OS

class CompanionEmotionEngine {
  /// Analyze app state and determine companion expression
  /// Maps Study OS intelligence → 18 facial states
  static CompanionEmotion analyze({
    required int todayMinutes,
    required int streak,
    required List<dynamic> exams,
    required int hour,
    required List<StudyTarget> targets,
  }) {
    // Calculate context data
    final urgentExams = exams.where((e) {
      final daysLeft = e['daysRemaining'] as int? ?? 999;
      return daysLeft <= 7 && daysLeft >= 0;
    }).toList();

    final urgentTargets = targets.where((t) {
      final daysLeft = t.endDate.difference(DateTime.now()).inDays;
      return !t.completed && daysLeft <= 3 && daysLeft >= 0;
    }).toList();

    // ================================================================
    // PRIORITY 1: EXAM CRISIS MODE (≤ 2 days)
    // ================================================================
    final criticalExams = urgentExams.where((e) {
      final daysLeft = e['daysRemaining'] as int;
      return daysLeft <= 2;
    }).toList();

    if (criticalExams.isNotEmpty) {
      final exam = criticalExams.first;
      final daysLeft = exam['daysRemaining'] as int;
      
      if (daysLeft == 0) {
        return CompanionEmotion(
          state: CompanionState.serious_2, // ULTRA SERIOUS
          reason: '${exam['subject']} exam TODAY. Final push.',
          category: 'exam_today',
        );
      } else if (daysLeft == 1) {
        return CompanionEmotion(
          state: CompanionState.serious_2, // ULTRA SERIOUS
          reason: '${exam['subject']} tomorrow. Review mode.',
          category: 'exam_tomorrow',
        );
      } else {
        return CompanionEmotion(
          state: CompanionState.serious_1, // SERIOUS FOCUS
          reason: '$daysLeft days until ${exam['subject']}. Lock in.',
          category: 'exam_close',
        );
      }
    }

    // ================================================================
    // PRIORITY 2: EXAM PREP MODE (3-7 days)
    // ================================================================
    if (urgentExams.isNotEmpty) {
      final exam = urgentExams.first;
      final daysLeft = exam['daysRemaining'] as int;
      return CompanionEmotion(
        state: CompanionState.serious_1, // Focused preparation
        reason: '${exam['subject']} in $daysLeft days. Stay sharp.',
        category: 'exam_prep',
      );
    }

    // ================================================================
    // PRIORITY 3: DEADLINE STRESS (Targets due soon)
    // ================================================================
    if (urgentTargets.isNotEmpty && todayMinutes < 30) {
      return CompanionEmotion(
        state: CompanionState.serious_1, // Serious focus
        reason: '${urgentTargets.length} deadline${urgentTargets.length > 1 ? 's' : ''} approaching. Time to focus.',
        category: 'deadline_stress',
      );
    }

    // ================================================================
    // PRIORITY 4: DRIFT ALERT (No study, streak at risk)
    // ================================================================
    if (todayMinutes == 0 && hour >= 18 && streak > 0) {
      if (streak >= 7) {
        return CompanionEmotion(
          state: CompanionState.eyes_closed_2, // Disappointed
          reason: '${streak}-day streak at risk. Don\'t break it now.',
          category: 'drift_high_streak',
        );
      } else {
        return CompanionEmotion(
          state: CompanionState.eyes_closed_1, // Concerned
          reason: 'No study yet today. Keep that consistency.',
          category: 'drift_low_streak',
        );
      }
    }

    // ================================================================
    // PRIORITY 5: ELITE PERFORMANCE (90+ mins, high streak)
    // ================================================================
    if (todayMinutes >= 90 && streak >= 14) {
      return CompanionEmotion(
        state: CompanionState.smile_confident, // CONFIDENT MASTERY
        reason: '$todayMinutes mins • ${streak}-day streak • ELITE LEVEL!',
        category: 'mastery',
      );
    }

    if (todayMinutes >= 90 && streak >= 7) {
      return CompanionEmotion(
        state: CompanionState.smile_confident, // Confident
        reason: '$todayMinutes minutes today! Crushing it!',
        category: 'high_performance',
      );
    }

    // ================================================================
    // PRIORITY 6: STRONG SESSION (60-90 mins)
    // ================================================================
    if (todayMinutes >= 60) {
      if (streak >= 7) {
        return CompanionEmotion(
          state: CompanionState.smile_big, // Big smile
          reason: '$todayMinutes mins • ${streak}-day streak • Strong work!',
          category: 'strong_session',
        );
      } else {
        return CompanionEmotion(
          state: CompanionState.smile_big, // Happy
          reason: '$todayMinutes minutes of focused work. Keep it up!',
          category: 'good_progress',
        );
      }
    }

    // ================================================================
    // PRIORITY 7: GOOD START (25-60 mins)
    // ================================================================
    if (todayMinutes >= 25 && todayMinutes < 60) {
      return CompanionEmotion(
        state: CompanionState.smile_soft, // Gentle smile
        reason: 'Good start. Build that momentum.',
        category: 'early_progress',
      );
    }

    // ================================================================
    // PRIORITY 8: FRESH START (Beginning of session, 1-25 mins)
    // ================================================================
    if (todayMinutes > 0 && todayMinutes < 25) {
      return CompanionEmotion(
        state: CompanionState.smile_soft, // Encouraging
        reason: 'Just getting started. Let\'s go.',
        category: 'fresh_start',
      );
    }

    // ================================================================
    // PRIORITY 9: SLEEPING HOURS (Night, no activity)
    // ================================================================
    if (hour >= 22 || hour <= 5) {
      if (todayMinutes >= 60) {
        // Studied well, now resting
        return CompanionEmotion(
          state: CompanionState.eyes_closed_soft, // Peaceful sleep
          reason: 'Day well spent. Rest and recover.',
          category: 'earned_rest',
        );
      } else {
        // Night mode
        return CompanionEmotion(
          state: CompanionState.eyes_closed_1, // Sleeping
          reason: 'Night mode. See you tomorrow.',
          category: 'sleeping',
        );
      }
    }

    // ================================================================
    // PRIORITY 10: MORNING ENERGY (Early hours, ready to work)
    // ================================================================
    if (hour >= 6 && hour <= 11) {
      if (streak >= 7 && todayMinutes == 0) {
        return CompanionEmotion(
          state: CompanionState.neutral_default, // Alert and ready
          reason: 'Morning champion. ${streak}-day streak. Let\'s keep it alive.',
          category: 'morning_motivated',
        );
      } else if (todayMinutes == 0) {
        return CompanionEmotion(
          state: CompanionState.neutral_default, // Ready
          reason: 'Your brain is sharpest now. Make it count.',
          category: 'morning_fresh',
        );
      }
    }

    // ================================================================
    // PRIORITY 11: AFTERNOON FOCUS (12-17, work mode)
    // ================================================================
    if (hour >= 12 && hour < 17 && todayMinutes == 0) {
      if (targets.isNotEmpty) {
        return CompanionEmotion(
          state: CompanionState.neutral_default, // Focused
          reason: 'Afternoon. Time to tackle those targets.',
          category: 'afternoon_focus',
        );
      }
    }

    // ================================================================
    // PRIORITY 12: EVENING WINDOW (17-22, prime study time)
    // ================================================================
    if (hour >= 17 && hour < 22 && todayMinutes == 0) {
      return CompanionEmotion(
        state: CompanionState.neutral_default, // Ready
        reason: 'Evening window. This is your power hour.',
        category: 'evening_prime',
      );
    }

    // ================================================================
    // DEFAULT: IDLE/READY
    // ================================================================
    return CompanionEmotion(
      state: CompanionState.neutral_default,
      reason: 'Ready when you are. Let\'s dominate.',
      category: 'idle',
    );
  }
}

/// Companion Emotion Data
class CompanionEmotion {
  final CompanionState state;
  final String reason;
  final String category;

  CompanionEmotion({
    required this.state,
    required this.reason,
    required this.category,
  });
}

