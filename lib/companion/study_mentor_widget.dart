import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'companion_state.dart';
import 'character_states.dart';

/// Study Mentor Character Widget - A real companion with face and expressions
/// NOT an abstract visualization - this is a character you can connect with
class StudyMentorWidget extends StatefulWidget {
  final CompanionEmotionData emotion;
  final double size;

  const StudyMentorWidget({
    super.key,
    required this.emotion,
    this.size = 120,
  });

  @override
  State<StudyMentorWidget> createState() => _StudyMentorWidgetState();
}

class _StudyMentorWidgetState extends State<StudyMentorWidget>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _breathingController;
  late Animation<double> _floatAnimation;
  late Animation<double> _breathingAnimation;
  
  String? _previousAssetPath;
  AnimationParams? _params;

  @override
  void initState() {
    super.initState();
    _params = AnimationParams.forState(widget.emotion.state);
    _previousAssetPath = CharacterAssets.getAssetPath(widget.emotion.state);
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(StudyMentorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emotion.state != widget.emotion.state) {
      _previousAssetPath = CharacterAssets.getAssetPath(oldWidget.emotion.state);
      _params = AnimationParams.forState(widget.emotion.state);
      _updateAnimations();
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Float animation (up/down motion)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    );

    // Breathing/scale animation
    _breathingController = AnimationController(
      vsync: this,
      duration: _params!.breathingDuration,
    )..repeat(reverse: true);

    _breathingAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    );
  }

  void _updateAnimations() {
    _breathingController.duration = _params!.breathingDuration;
  }

  Offset _getFloatOffset() {
    final t = _floatAnimation.value;
    final distance = _params!.floatDistance;
    
    if (widget.emotion.state == CompanionState.proud) {
      // Upward bounce for proud
      return Offset(0, -distance * (1 - t));
    } else if (widget.emotion.state == CompanionState.disappointed) {
      // Slow droop for disappointed
      return Offset(0, distance * 0.5);
    } else if (widget.emotion.state == CompanionState.curious) {
      // Side-to-side tilt
      return Offset(math.sin(t * math.pi * 2) * 3, -distance * t);
    }
    
    // Default gentle float
    return Offset(0, -distance * t);
  }

  double _getBreathingScale() {
    final t = _breathingAnimation.value;
    final range = _params!.scaleRange;
    return 1.0 + (range * t);
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = CharacterAssets.getAssetPath(widget.emotion.state);
    
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          _buildGlow(),
          
          // Character image with animations
          AnimatedBuilder(
            animation: Listenable.merge([_floatController, _breathingController]),
            builder: (context, child) {
              return Transform.translate(
                offset: _getFloatOffset(),
                child: Transform.scale(
                  scale: _getBreathingScale(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: Image.asset(
                      assetPath,
                      key: ValueKey(assetPath),
                      width: widget.size * 0.85,
                      height: widget.size * 0.85,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image fails to load
                        return Container(
                          width: widget.size * 0.85,
                          height: widget.size * 0.85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _params!.glowColor.withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Color overlay for state intensity
          _buildStateOverlay(),
        ],
      ),
    );
  }

  Widget _buildGlow() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _params!.glowColor.withOpacity(_params!.glowIntensity * 0.4),
            blurRadius: 40,
            spreadRadius: 20,
          ),
          BoxShadow(
            color: _params!.glowColor.withOpacity(_params!.glowIntensity * 0.2),
            blurRadius: 60,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildStateOverlay() {
    final state = widget.emotion.state;
    Color? overlayColor;
    double overlayIntensity = 0.0;

    switch (state) {
      case CompanionState.alert:
        overlayColor = const Color(0xFFFF2A4D);
        overlayIntensity = 0.3 * widget.emotion.intensity;
        break;
      case CompanionState.proud:
        overlayColor = const Color(0xFFFFCA28);
        overlayIntensity = 0.25 * widget.emotion.intensity;
        break;
      case CompanionState.disappointed:
        overlayColor = const Color(0xFF64748B);
        overlayIntensity = 0.2 * widget.emotion.intensity;
        break;
      case CompanionState.sleeping:
        overlayColor = const Color(0xFF0E1220);
        overlayIntensity = 0.4 * widget.emotion.intensity;
        break;
      default:
        return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        final pulse = state == CompanionState.alert
            ? (1 + math.sin(_breathingController.value * math.pi * 2) * 0.2)
            : 1.0;

        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  overlayColor!.withOpacity(overlayIntensity * pulse),
                  Colors.transparent,
                ],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

