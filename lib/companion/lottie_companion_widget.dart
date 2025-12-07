import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'companion_state.dart';

/// Lottie-based Companion Widget
/// 
/// Professional animated mascot using Lottie animations
/// Syncs with emotion engine and voice playback

class LottieCompanionWidget extends StatefulWidget {
  final CompanionState state;
  final bool isTalking;
  final double size;

  const LottieCompanionWidget({
    required this.state,
    this.isTalking = false,
    this.size = 200,
    super.key,
  });

  @override
  State<LottieCompanionWidget> createState() => _LottieCompanionWidgetState();
}

class _LottieCompanionWidgetState extends State<LottieCompanionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LottieCompanionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle talking state changes
    if (widget.isTalking != oldWidget.isTalking) {
      if (widget.isTalking) {
        _controller.repeat(); // Loop animation while talking
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  /// Get Lottie file path based on companion state
  String _getLottieFile() {
    // Map companion states to Lottie animation files
    
    // TALKING STATES - Use animated mascot
    if (widget.isTalking) {
      return 'assets/lottie/mascot_talking.json';
    }
    
    // EMOTIONAL STATES - Map to appropriate animations
    switch (widget.state) {
      // HAPPY/ACHIEVEMENT STATES
      case CompanionState.smile_soft:
      case CompanionState.smile_big:
      case CompanionState.smile_confident:
        return 'assets/lottie/mascot_happy.json';
      
      // SERIOUS/FOCUS STATES
      case CompanionState.serious_1:
      case CompanionState.serious_2:
        return 'assets/lottie/mascot_serious.json';
      
      // SLEEPING/RESTING STATES
      case CompanionState.eyes_closed_1:
      case CompanionState.eyes_closed_2:
      case CompanionState.eyes_closed_soft:
        return 'assets/lottie/mascot_sleeping.json';
      
      // NEUTRAL/DEFAULT
      case CompanionState.neutral_default:
      default:
        return 'assets/lottie/mascot_idle.json';
      
      // MOUTH STATES (only used during talking)
      case CompanionState.mouth_A_1:
      case CompanionState.mouth_A_2:
      case CompanionState.mouth_A_3:
      case CompanionState.mouth_A_4:
      case CompanionState.mouth_O_1:
      case CompanionState.mouth_O_2:
      case CompanionState.mouth_E_1:
      case CompanionState.mouth_E_2:
      case CompanionState.mouth_E_3:
        return 'assets/lottie/mascot_talking.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.asset(
        _getLottieFile(),
        controller: _controller,
        animate: !widget.isTalking, // Auto-play when not talking
        repeat: true,
        fit: BoxFit.contain,
        
        // Fallback for missing files
        errorBuilder: (context, error, stackTrace) {
          print('❌ Failed to load Lottie: ${_getLottieFile()}');
          return Center(
            child: Icon(
              Icons.sentiment_satisfied_alt,
              size: widget.size * 0.6,
              color: const Color(0xFF3B82F6),
            ),
          );
        },
        
        // Optional: onLoaded callback for advanced control
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          if (widget.isTalking) {
            _controller.repeat();
          }
        },
      ),
    );
  }
}

