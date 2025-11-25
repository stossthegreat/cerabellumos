import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'companion_state.dart';

/// CompanionController - Manages companion state and animations
/// 
/// Features:
/// - Automatic blinking animation
/// - Talking animation (mouth shapes)
/// - Emotion control
class CompanionController extends ChangeNotifier {
  CompanionState _currentState = CompanionState.neutral_default;
  bool _isTalking = false;
  bool _isBlinking = false;
  
  Timer? _blinkTimer;
  Timer? _talkTimer;
  Timer? _blinkSequenceTimer;
  
  final Random _random = Random();

  CompanionState get currentState => _currentState;
  bool get isTalking => _isTalking;

  CompanionController() {
    _startBlinkingLoop();
  }

  /// Set emotion/expression state manually
  void setEmotion(CompanionState state) {
    if (_isTalking || _isBlinking) return; // Don't interrupt animations
    _currentState = state;
    notifyListeners();
  }

  /// Start talking animation
  /// Cycles through mouth shapes: A → E → O → repeat
  void startTalking() {
    if (_isTalking) return;
    
    _isTalking = true;
    _stopBlinking(); // Pause blinking while talking
    
    print('🎤 Companion started talking');
    
    // Cycle through mouth shapes
    final mouthStates = [
      CompanionState.mouth_A_1,
      CompanionState.mouth_A_2,
      CompanionState.mouth_E_1,
      CompanionState.mouth_E_2,
      CompanionState.mouth_O_1,
      CompanionState.mouth_O_2,
      CompanionState.mouth_A_3,
      CompanionState.mouth_E_3,
      CompanionState.mouth_A_4,
    ];
    
    int currentIndex = 0;
    _talkTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!_isTalking) {
        timer.cancel();
        return;
      }
      
      _currentState = mouthStates[currentIndex % mouthStates.length];
      currentIndex++;
      notifyListeners();
    });
  }

  /// Stop talking animation
  void stopTalking() {
    if (!_isTalking) return;
    
    _isTalking = false;
    _talkTimer?.cancel();
    _talkTimer = null;
    
    _currentState = CompanionState.neutral_default;
    notifyListeners();
    
    print('🎤 Companion stopped talking');
    
    // Resume blinking
    _startBlinkingLoop();
  }

  /// Internal: Start blinking loop
  void _startBlinkingLoop() {
    _blinkTimer?.cancel();
    _scheduleNextBlink();
  }

  /// Internal: Schedule next blink (random 4-7 seconds)
  void _scheduleNextBlink() {
    if (_isTalking || _isBlinking) return;
    
    final nextBlinkDelay = Duration(seconds: 4 + _random.nextInt(4)); // 4-7 seconds
    
    _blinkTimer = Timer(nextBlinkDelay, () {
      _performBlink();
    });
  }

  /// Internal: Perform blink sequence
  void _performBlink() {
    if (_isTalking) {
      _scheduleNextBlink();
      return;
    }
    
    _isBlinking = true;
    final previousState = _currentState;
    
    // Blink sequence: neutral → closed_1 → closed_2 → closed_soft → back to previous
    final blinkSequence = [
      CompanionState.eyes_closed_1,
      CompanionState.eyes_closed_2,
      CompanionState.eyes_closed_soft,
      previousState,
    ];
    
    int stepIndex = 0;
    _blinkSequenceTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (stepIndex >= blinkSequence.length) {
        timer.cancel();
        _isBlinking = false;
        _currentState = previousState;
        notifyListeners();
        _scheduleNextBlink(); // Schedule next blink
        return;
      }
      
      _currentState = blinkSequence[stepIndex];
      stepIndex++;
      notifyListeners();
    });
  }

  /// Internal: Stop blinking (when talking starts)
  void _stopBlinking() {
    _blinkTimer?.cancel();
    _blinkSequenceTimer?.cancel();
    _blinkTimer = null;
    _blinkSequenceTimer = null;
    _isBlinking = false;
  }

  /// Trigger talk with duration estimate
  Future<void> triggerTalk(String text) async {
    startTalking();
    
    // Estimate duration based on text length
    final wordCount = text.split(' ').length;
    final duration = Duration(milliseconds: (wordCount * 150).clamp(1000, 10000));
    
    await Future.delayed(duration);
    
    stopTalking();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _talkTimer?.cancel();
    _blinkSequenceTimer?.cancel();
    super.dispose();
  }
}
