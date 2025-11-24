import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'companion_controller.dart';
import 'expression_state.dart';
import 'animation_state.dart' as anim;

/// Companion View Widget - Renders the companion PNG with animations
/// 
/// CRITICAL RULES:
/// - ONLY loads user-provided PNG files
/// - NO placeholder generation
/// - NO drawing or approximation
/// - Animations NEVER distort the PNG

class CompanionView extends StatefulWidget {
  final double size;

  const CompanionView({
    super.key,
    this.size = 140,
  });

  @override
  State<CompanionView> createState() => _CompanionViewState();
}

class _CompanionViewState extends State<CompanionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    final controller = context.read<CompanionController>();
    final config = anim.AnimationConfig.forState(controller.animation);
    
    _animationController = AnimationController(
      vsync: this,
      duration: config.duration,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: config.curve,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanionController>(
      builder: (context, controller, child) {
        // Update animation if state changed
        final config = anim.AnimationConfig.forState(controller.animation);
        if (_animationController.duration != config.duration) {
          _animationController.duration = config.duration;
        }

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildAnimatedImage(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedImage(CompanionController controller) {
    final assetPath = ExpressionAssets.getAssetPath(controller.expression);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final offset = _getAnimationOffset(controller.animation);
        final opacity = _getAnimationOpacity(controller.animation);

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacity,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: Image.asset(
                assetPath,
                key: ValueKey(assetPath),
                width: widget.size * 0.85,
                height: widget.size * 0.85,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Error: Asset missing
                  print('⚠️ Missing companion asset: $assetPath');
                  print('   Error: $error');
                  
                  // Try to fallback to neutral
                  if (assetPath != 'assets/companion/neutral.png') {
                    return Image.asset(
                      'assets/companion/neutral.png',
                      width: widget.size * 0.85,
                      height: widget.size * 0.85,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        // Critical: Even neutral is missing
                        return _buildErrorPlaceholder();
                      },
                    );
                  }
                  
                  return _buildErrorPlaceholder();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: widget.size * 0.85,
      height: widget.size * 0.85,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 8),
          Text(
            'Missing PNG',
            style: TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Offset _getAnimationOffset(anim.AnimationState state) {
    final t = _animation.value;
    final config = anim.AnimationConfig.forState(state);

    switch (state) {
      case anim.AnimationState.float:
        // Gentle up/down
        return Offset(0, -config.intensity * t);

      case anim.AnimationState.pulse:
        // No movement, just opacity
        return Offset.zero;

      case anim.AnimationState.shakeLight:
        // Side-to-side shake
        return Offset(
          math.sin(t * math.pi * 4) * config.intensity,
          0,
        );

      case anim.AnimationState.popIn:
        // No offset for pop-in (uses scale instead)
        return Offset.zero;
    }
  }

  double _getAnimationOpacity(anim.AnimationState state) {
    final t = _animation.value;
    final config = anim.AnimationConfig.forState(state);

    switch (state) {
      case anim.AnimationState.pulse:
        // Opacity pulse
        return 1.0 - (config.intensity * t);

      case anim.AnimationState.float:
      case anim.AnimationState.shakeLight:
      case anim.AnimationState.popIn:
        // Full opacity for other animations
        return 1.0;
    }
  }
}

