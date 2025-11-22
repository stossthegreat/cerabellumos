import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double height;
  final double? width;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Color? shadowColor;
  final bool enabled;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientColors = const [Color(0xFF8B5CF6), Color(0xFFA855F7)],
    this.height = 60,
    this.width,
    this.borderRadius = 16,
    this.textStyle,
    this.padding,
    this.shadowColor,
    this.enabled = true,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: widget.enabled
                  ? widget.gradientColors
                  : [Colors.grey.shade700, Colors.grey.shade800],
            ),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: (widget.shadowColor ?? widget.gradientColors.first)
                          .withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: widget.textStyle ??
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

