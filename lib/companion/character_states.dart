import 'package:flutter/material.dart';
import 'companion_state.dart';

/// Maps CompanionState to character image assets
class CharacterAssets {
  static String getAssetPath(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return 'assets/character/study/mentor_idle.png';
      case CompanionState.focused:
        return 'assets/character/study/mentor_focus.png';
      case CompanionState.alert:
        return 'assets/character/study/mentor_alert.png';
      case CompanionState.proud:
        return 'assets/character/study/mentor_proud.png';
      case CompanionState.disappointed:
        return 'assets/character/study/mentor_disappointed.png';
      case CompanionState.sleeping:
        return 'assets/character/study/mentor_sleep.png';
      case CompanionState.curious:
        return 'assets/character/study/mentor_focus.png'; // Reuse focus
    }
  }
}

/// Animation parameters for each character state
class AnimationParams {
  final double floatDistance;
  final double scaleRange;
  final Duration breathingDuration;
  final Color glowColor;
  final double glowIntensity;

  const AnimationParams({
    required this.floatDistance,
    required this.scaleRange,
    required this.breathingDuration,
    required this.glowColor,
    required this.glowIntensity,
  });

  static AnimationParams forState(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const AnimationParams(
          floatDistance: 8,
          scaleRange: 0.03,
          breathingDuration: Duration(milliseconds: 3000),
          glowColor: Color(0xFF6CCAFF),
          glowIntensity: 0.3,
        );

      case CompanionState.focused:
        return const AnimationParams(
          floatDistance: 5,
          scaleRange: 0.05,
          breathingDuration: Duration(milliseconds: 1500),
          glowColor: Color(0xFF00E7FF),
          glowIntensity: 0.6,
        );

      case CompanionState.alert:
        return const AnimationParams(
          floatDistance: 3,
          scaleRange: 0.08,
          breathingDuration: Duration(milliseconds: 800),
          glowColor: Color(0xFFFF2A4D),
          glowIntensity: 0.9,
        );

      case CompanionState.proud:
        return const AnimationParams(
          floatDistance: 12,
          scaleRange: 0.06,
          breathingDuration: Duration(milliseconds: 1200),
          glowColor: Color(0xFFFFCA28),
          glowIntensity: 0.85,
        );

      case CompanionState.disappointed:
        return const AnimationParams(
          floatDistance: 4,
          scaleRange: 0.02,
          breathingDuration: Duration(milliseconds: 4000),
          glowColor: Color(0xFF64748B),
          glowIntensity: 0.2,
        );

      case CompanionState.curious:
        return const AnimationParams(
          floatDistance: 6,
          scaleRange: 0.04,
          breathingDuration: Duration(milliseconds: 2000),
          glowColor: Color(0xFFA37BFF),
          glowIntensity: 0.5,
        );

      case CompanionState.sleeping:
        return const AnimationParams(
          floatDistance: 10,
          scaleRange: 0.02,
          breathingDuration: Duration(milliseconds: 4500),
          glowColor: Color(0xFF6366F1),
          glowIntensity: 0.15,
        );
    }
  }
}

