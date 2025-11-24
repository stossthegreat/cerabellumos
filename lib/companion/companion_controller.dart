import 'package:flutter/material.dart';
import 'expression_state.dart';
import 'behavior_state.dart';
import 'animation_state.dart';

/// Main Companion Controller - Connects all 3 state machines
/// 
/// This is the central state machine that coordinates:
/// 1. Expression State (which PNG to show)
/// 2. Behavior State (context/reason for expression)
/// 3. Animation State (micro-animations applied to PNG)

class CompanionController extends ChangeNotifier {
  ExpressionState _currentExpression = ExpressionState.neutral;
  BehaviorState _currentBehavior = BehaviorState.idle;
  AnimationState _currentAnimation = AnimationState.float;
  
  ExpressionState? _expressionOverride; // Temporary expression override
  DateTime? _overrideExpiry;

  // Getters
  ExpressionState get expression {
    // Check for active override
    if (_expressionOverride != null && _overrideExpiry != null) {
      if (DateTime.now().isBefore(_overrideExpiry!)) {
        return _expressionOverride!;
      } else {
        // Override expired, clear it
        _expressionOverride = null;
        _overrideExpiry = null;
      }
    }
    return _currentExpression;
  }

  BehaviorState get behavior => _currentBehavior;
  AnimationState get animation => _currentAnimation;

  /// Set the behavior state (will automatically update expression)
  void setBehaviorState(BehaviorState state) {
    if (_currentBehavior != state) {
      _currentBehavior = state;
      
      // Map behavior to expression (unless overridden)
      if (_expressionOverride == null) {
        final hour = DateTime.now().hour;
        _currentExpression = BehaviorToExpression.getExpression(state, hour);
        
        // Update animation based on behavior
        _updateAnimationForBehavior(state);
      }
      
      notifyListeners();
    }
  }

  /// Temporarily override the expression (e.g., for talking)
  void setExpressionOverride(ExpressionState state, {Duration? duration}) {
    _expressionOverride = state;
    _overrideExpiry = duration != null
        ? DateTime.now().add(duration)
        : DateTime.now().add(const Duration(seconds: 3));
    notifyListeners();
  }

  /// Clear any active expression override
  void clearOverride() {
    _expressionOverride = null;
    _overrideExpiry = null;
    notifyListeners();
  }

  /// Trigger talking mode (switches to talkingOpen expression temporarily)
  Future<void> triggerTalk(String text) async {
    // Store current state
    final previousExpression = _currentExpression;
    final previousAnimation = _currentAnimation;

    // Switch to talking
    setExpressionOverride(ExpressionState.talkingOpen);
    _currentAnimation = AnimationState.pulse;
    notifyListeners();

    // Simulate TTS duration (estimate ~0.15s per word)
    final wordCount = text.split(' ').length;
    final duration = Duration(milliseconds: (wordCount * 150).clamp(1000, 5000));
    await Future.delayed(duration);

    // Restore previous state
    _expressionOverride = null;
    _overrideExpiry = null;
    _currentExpression = previousExpression;
    _currentAnimation = previousAnimation;
    notifyListeners();
  }

  /// Trigger alert animation (shake + alert expression)
  void triggerAlert() {
    setBehaviorState(BehaviorState.examStress);
    _currentAnimation = AnimationState.shakeLight;
    notifyListeners();

    // Return to normal animation after shake completes
    Future.delayed(const Duration(milliseconds: 500), () {
      _currentAnimation = AnimationState.float;
      notifyListeners();
    });
  }

  /// Trigger celebration (smile + pop-in)
  void triggerCelebration() {
    setBehaviorState(BehaviorState.celebration);
    _currentAnimation = AnimationState.popIn;
    notifyListeners();

    // Return to float after pop-in
    Future.delayed(const Duration(milliseconds: 300), () {
      _currentAnimation = AnimationState.float;
      notifyListeners();
    });
  }

  /// Update companion based on app state data
  void updateFromAppState({
    required int todayMinutes,
    required int streak,
    required List<dynamic> exams,
    required int hour,
  }) {
    // Check for exam stress (highest priority)
    final criticalExam = exams.any((e) => (e['days'] as int) <= 5);
    if (criticalExam) {
      setBehaviorState(BehaviorState.examStress);
      return;
    }

    // Check for celebration (good progress)
    if (todayMinutes >= 60 && streak > 0) {
      setBehaviorState(BehaviorState.celebration);
      return;
    }

    // Check for drift/warning (no progress by evening)
    if (hour >= 18 && todayMinutes == 0) {
      setBehaviorState(BehaviorState.warning);
      return;
    }

    // Check for sleeping (night hours)
    if (hour >= 22 || hour < 6) {
      setBehaviorState(BehaviorState.sleeping);
      return;
    }

    // Default: idle
    setBehaviorState(BehaviorState.idle);
  }

  /// Update animation based on behavior
  void _updateAnimationForBehavior(BehaviorState behavior) {
    switch (behavior) {
      case BehaviorState.idle:
      case BehaviorState.sleeping:
        _currentAnimation = AnimationState.float;
        break;
      case BehaviorState.coaching:
        _currentAnimation = AnimationState.pulse;
        break;
      case BehaviorState.warning:
        _currentAnimation = AnimationState.float;
        break;
      case BehaviorState.celebration:
        _currentAnimation = AnimationState.popIn;
        break;
      case BehaviorState.examStress:
        _currentAnimation = AnimationState.shakeLight;
        break;
    }
  }
}

