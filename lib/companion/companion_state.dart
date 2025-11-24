/// The 7 emotional states of the Study Companion
enum CompanionState {
  /// Soft breathing + faint ambient glow
  /// Default resting state
  idle,

  /// Mild forward lean + brighter glow
  /// When user is actively studying
  focused,

  /// Quick pulse + wider eyes
  /// When exam is close (< 5 days)
  alert,

  /// Gentle upward bounce + warm radiant glow
  /// When user completes a goal or milestone
  proud,

  /// Dim + slight downward droop
  /// When user is falling behind
  disappointed,

  /// Head tilt + eyes widen
  /// Random variation to feel alive
  curious,

  /// Eyes closed + slow dim pulse
  /// During night hours (22:00-6:00)
  sleeping,
}

/// Emotion data that drives the companion's visual state
class CompanionEmotionData {
  final CompanionState state;
  final String reason;
  final double intensity;

  const CompanionEmotionData({
    required this.state,
    required this.reason,
    this.intensity = 1.0,
  });

  @override
  String toString() => 'CompanionEmotionData($state, "$reason", intensity: $intensity)';
}

