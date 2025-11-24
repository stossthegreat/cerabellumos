import 'package:flutter/material.dart';

/// Micro-Animation State Machine - Controls tiny UI animations applied to PNGs
/// 
/// CRITICAL: Animations NEVER distort the PNG. Only position, opacity, scale.

enum AnimationState {
  float,      // Gentle up/down motion
  pulse,      // Opacity pulse
  shakeLight, // Light shake for alerts
  popIn,      // Scale in on state change
}

/// Configuration for each animation type
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final double intensity;

  const AnimationConfig({
    required this.duration,
    required this.curve,
    required this.intensity,
  });

  static AnimationConfig forState(AnimationState state) {
    switch (state) {
      case AnimationState.float:
        return const AnimationConfig(
          duration: Duration(milliseconds: 2500),
          curve: Curves.easeInOut,
          intensity: 8.0, // pixels up/down
        );

      case AnimationState.pulse:
        return const AnimationConfig(
          duration: Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          intensity: 0.15, // opacity range (0.85 - 1.0)
        );

      case AnimationState.shakeLight:
        return const AnimationConfig(
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          intensity: 5.0, // pixels side-to-side
        );

      case AnimationState.popIn:
        return const AnimationConfig(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          intensity: 1.2, // scale factor
        );
    }
  }

  /// Get human-readable label for animation
  static String getLabel(AnimationState state) {
    switch (state) {
      case AnimationState.float:
        return 'Float';
      case AnimationState.pulse:
        return 'Pulse';
      case AnimationState.shakeLight:
        return 'Shake (Light)';
      case AnimationState.popIn:
        return 'Pop In';
    }
  }
}

