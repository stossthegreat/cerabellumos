/// Expression State Machine - Controls which PNG is displayed
/// 
/// CRITICAL: This system ONLY loads user-provided PNG assets.
/// NO placeholder generation. NO drawing. NO approximations.

enum ExpressionState {
  neutral,        // Default calm state
  smile,          // Happy/positive
  closedEyesCalm, // Sleeping/resting
  talkingOpen,    // Speaking/coaching
  worried,        // Concerned/drift
  alert,          // Urgent/exam stress
}

/// Maps expression states to user-provided PNG asset paths
class ExpressionAssets {
  static String getAssetPath(ExpressionState state) {
    switch (state) {
      case ExpressionState.neutral:
        return 'assets/companion/neutral.png';
      case ExpressionState.smile:
        return 'assets/companion/smile.png';
      case ExpressionState.closedEyesCalm:
        return 'assets/companion/closed_eyes.png';
      case ExpressionState.talkingOpen:
        return 'assets/companion/talking_open.png';
      case ExpressionState.worried:
        return 'assets/companion/worried.png';
      case ExpressionState.alert:
        return 'assets/companion/alert.png';
    }
  }

  /// Get human-readable label for expression
  static String getLabel(ExpressionState state) {
    switch (state) {
      case ExpressionState.neutral:
        return 'Neutral';
      case ExpressionState.smile:
        return 'Smile';
      case ExpressionState.closedEyesCalm:
        return 'Closed Eyes (Calm)';
      case ExpressionState.talkingOpen:
        return 'Talking (Open)';
      case ExpressionState.worried:
        return 'Worried';
      case ExpressionState.alert:
        return 'Alert';
    }
  }
}

