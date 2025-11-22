import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBlob extends StatefulWidget {
  final Color color;
  final double size;
  final double initialX;
  final double initialY;
  final Duration duration;
  final double maxOffset;

  const AnimatedBlob({
    super.key,
    required this.color,
    this.size = 400,
    this.initialX = -100,
    this.initialY = -100,
    this.duration = const Duration(seconds: 7),
    this.maxOffset = 50,
  });

  @override
  State<AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        
        // Custom blob animation path (translate + scale)
        double offsetX = 0;
        double offsetY = 0;
        double scale = 1.0;

        if (t < 0.25) {
          final progress = t / 0.25;
          offsetX = 20 * progress;
          offsetY = -50 * progress;
          scale = 1.0 + 0.1 * progress;
        } else if (t < 0.5) {
          final progress = (t - 0.25) / 0.25;
          offsetX = 20 - 40 * progress;
          offsetY = -50 + 70 * progress;
          scale = 1.1 - 0.2 * progress;
        } else if (t < 0.75) {
          final progress = (t - 0.5) / 0.25;
          offsetX = -20 + 70 * progress;
          offsetY = 20 + 30 * progress;
          scale = 0.9 + 0.15 * progress;
        } else {
          final progress = (t - 0.75) / 0.25;
          offsetX = 50 - 50 * progress;
          offsetY = 50 - 50 * progress;
          scale = 1.05 - 0.05 * progress;
        }

        return Positioned(
          left: widget.initialX + offsetX,
          top: widget.initialY + offsetY,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color,
                    Colors.transparent,
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        );
      },
    );
  }
}

