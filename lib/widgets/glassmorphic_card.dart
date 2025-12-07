import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/design_tokens.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors; // DEPRECATED - kept for backwards compatibility
  final VoidCallback? onTap;
  final double blur;
  final bool elevated;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.gradientColors, // DEPRECATED - use backgroundColor instead
    this.onTap,
    this.blur = 10,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? DesignTokens.radiusLarge;
    final effectiveBackgroundColor = backgroundColor ?? DesignTokens.surfaceDefault.withOpacity(0.9);
    final effectiveBorderColor = borderColor ?? DesignTokens.borderDefault;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: 1.5,
            ),
            boxShadow: elevated 
                ? [
                    BoxShadow(
                      color: DesignTokens.energyOrange.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}

