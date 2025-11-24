import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'companion_state.dart';

/// The living, animated study companion that reacts to user behavior
class CompanionWidget extends StatefulWidget {
  final CompanionEmotionData emotion;
  final double size;

  const CompanionWidget({
    super.key,
    required this.emotion,
    this.size = 120,
  });

  @override
  State<CompanionWidget> createState() => _CompanionWidgetState();
}

class _CompanionWidgetState extends State<CompanionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _getDuration(widget.emotion.state),
    )..repeat(reverse: _shouldReverse(widget.emotion.state));
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: _getCurve(widget.emotion.state),
    );
  }

  @override
  void didUpdateWidget(CompanionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emotion.state != widget.emotion.state) {
      // Smooth transition between states
      _controller.stop();
      _controller.duration = _getDuration(widget.emotion.state);
      _controller.value = 0.0;
      _controller.repeat(reverse: _shouldReverse(widget.emotion.state));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration _getDuration(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const Duration(milliseconds: 3000);
      case CompanionState.focused:
        return const Duration(milliseconds: 1500);
      case CompanionState.alert:
        return const Duration(milliseconds: 800);
      case CompanionState.proud:
        return const Duration(milliseconds: 1200);
      case CompanionState.disappointed:
        return const Duration(milliseconds: 2500);
      case CompanionState.curious:
        return const Duration(milliseconds: 2000);
      case CompanionState.sleeping:
        return const Duration(milliseconds: 4000);
    }
  }

  bool _shouldReverse(CompanionState state) {
    return state != CompanionState.proud; // Proud bounces up only
  }

  Curve _getCurve(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return Curves.easeInOut;
      case CompanionState.focused:
        return Curves.easeOut;
      case CompanionState.alert:
        return Curves.elasticInOut;
      case CompanionState.proud:
        return Curves.bounceOut;
      case CompanionState.disappointed:
        return Curves.easeInOut;
      case CompanionState.curious:
        return Curves.easeInOutCubic;
      case CompanionState.sleeping:
        return Curves.easeInOut;
    }
  }

  Color _getColor(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const Color(0xFF0EA5E9); // primary blue
      case CompanionState.focused:
        return const Color(0xFF3B82F6); // bright blue
      case CompanionState.alert:
        return const Color(0xFFF97316); // warning orange
      case CompanionState.proud:
        return const Color(0xFFFBBF24); // success gold
      case CompanionState.disappointed:
        return const Color(0xFF64748B); // muted blue
      case CompanionState.curious:
        return const Color(0xFF06B6D4); // cyan
      case CompanionState.sleeping:
        return const Color(0xFF6366F1); // deep purple
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return _buildAnimatedCompanion();
        },
      ),
    );
  }

  Widget _buildAnimatedCompanion() {
    final state = widget.emotion.state;
    final t = _animation.value;
    
    // Calculate transforms based on state
    double scale = 1.0;
    double offsetY = 0.0;
    double rotation = 0.0;
    double eyeHeight = 16.0;
    double eyeWidth = 12.0;
    double glowIntensity = widget.emotion.intensity;

    switch (state) {
      case CompanionState.idle:
        scale = 1.0 + (0.05 * t);
        eyeHeight = 16.0;
        eyeWidth = 12.0;
        break;

      case CompanionState.focused:
        scale = 1.0 + (0.08 * t);
        eyeHeight = 18.0;
        eyeWidth = 13.0;
        glowIntensity = 0.9;
        break;

      case CompanionState.alert:
        scale = 1.0 + (0.15 * math.sin(t * math.pi * 2));
        eyeHeight = 20.0;
        eyeWidth = 14.0;
        glowIntensity = 1.0;
        break;

      case CompanionState.proud:
        // Enhanced bounce with multiple phases
        if (t < 0.3) {
          scale = 1.0 + (0.15 * t / 0.3);
          offsetY = -15.0 * (t / 0.3);
        } else if (t < 0.5) {
          final bounce = (t - 0.3) / 0.2;
          scale = 1.15 - (0.1 * bounce);
          offsetY = -15.0 + (5.0 * bounce);
        } else {
          final settle = (t - 0.5) / 0.5;
          scale = 1.05 - (0.05 * settle);
          offsetY = -10.0 + (10.0 * settle);
        }
        eyeHeight = 18.0;
        eyeWidth = 13.0;
        glowIntensity = 0.95 + (0.05 * math.sin(t * math.pi * 4));
        break;

      case CompanionState.disappointed:
        scale = 0.95;
        offsetY = 5.0;
        eyeHeight = 12.0;
        eyeWidth = 10.0;
        glowIntensity = 0.4;
        break;

      case CompanionState.curious:
        rotation = 8.0 * math.sin(t * math.pi);
        eyeHeight = 17.0;
        eyeWidth = 13.0;
        glowIntensity = 0.75;
        break;

      case CompanionState.sleeping:
        scale = 0.9 + (0.05 * t);
        eyeHeight = 2.0; // Eyes closed
        eyeWidth = 12.0;
        glowIntensity = 0.25;
        break;
    }

    final color = _getColor(state);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Transform.rotate(
        angle: rotation * math.pi / 180,
        child: Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow layers (soft, diffuse)
              _buildGlow(color, glowIntensity, 50, 0.15),
              _buildGlow(color, glowIntensity, 35, 0.25),
              _buildGlow(color, glowIntensity, 22, 0.4),
              
              // Main body with enhanced gradient
              Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.9 * glowIntensity),
                      color.withOpacity(0.6 * glowIntensity),
                      color.withOpacity(0.3 * glowIntensity),
                      color.withOpacity(0.05 * glowIntensity),
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5 * glowIntensity),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),

              // Eyes
              Positioned(
                left: widget.size * 0.35,
                top: widget.size * 0.4,
                child: _buildEye(eyeWidth, eyeHeight, color),
              ),
              Positioned(
                right: widget.size * 0.35,
                top: widget.size * 0.4,
                child: _buildEye(eyeWidth, eyeHeight, color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlow(Color color, double intensity, double blur, double opacity) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(opacity * intensity),
            blurRadius: blur * intensity,
            spreadRadius: 5 * intensity,
          ),
        ],
      ),
    );
  }

  Widget _buildEye(double width, double height, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 2,
            offset: const Offset(-1, -1),
          ),
        ],
      ),
      child: height > 5 // Only show pupil when eyes are open
          ? Center(
              child: Container(
                width: width * 0.4,
                height: height * 0.5,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(height / 4),
                ),
              ),
            )
          : null,
    );
  }
}

