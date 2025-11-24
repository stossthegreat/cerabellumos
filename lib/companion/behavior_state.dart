import 'expression_state.dart';

/// Behavior State Machine - Controls WHY a face appears (context)
/// 
/// This translates app events and study patterns into appropriate expressions

enum BehaviorState {
  idle,         // Default app state
  coaching,     // AI is helping
  warning,      // Drift/issues detected
  celebration,  // Achievement unlocked
  examStress,   // Exam approaching
  sleeping,     // Night hours
}

/// Maps behavior contexts to appropriate facial expressions
class BehaviorToExpression {
  /// Determine the appropriate expression based on behavior and time
  static ExpressionState getExpression(
    BehaviorState behavior,
    int hour, // Current hour for time-based decisions
  ) {
    switch (behavior) {
      case BehaviorState.idle:
        // During night hours, show sleeping face
        return (hour >= 22 || hour < 6)
            ? ExpressionState.closedEyesCalm
            : ExpressionState.neutral;

      case BehaviorState.coaching:
        return ExpressionState.smile;

      case BehaviorState.warning:
        return ExpressionState.worried;

      case BehaviorState.celebration:
        return ExpressionState.smile;

      case BehaviorState.examStress:
        return ExpressionState.alert;

      case BehaviorState.sleeping:
        return ExpressionState.closedEyesCalm;
    }
  }

  /// Get human-readable label for behavior
  static String getLabel(BehaviorState state) {
    switch (state) {
      case BehaviorState.idle:
        return 'Idle';
      case BehaviorState.coaching:
        return 'Coaching';
      case BehaviorState.warning:
        return 'Warning';
      case BehaviorState.celebration:
        return 'Celebration';
      case BehaviorState.examStress:
        return 'Exam Stress';
      case BehaviorState.sleeping:
        return 'Sleeping';
    }
  }
}

