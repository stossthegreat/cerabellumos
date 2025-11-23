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
    final effectiveBorderRadius = borderRadius ?? DesignTokens.radiusMedium;
    final effectiveBackgroundColor = backgroundColor ?? DesignTokens.surfaceDefault;
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
              width: 1,
            ),
            boxShadow: elevated ? DesignTokens.shadowSmall : null,
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

