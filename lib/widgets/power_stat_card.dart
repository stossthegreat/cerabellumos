import 'package:flutter/material.dart';
import 'glassmorphic_card.dart';

class PowerStatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const PowerStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<PowerStatCard> createState() => _PowerStatCardState();
}

class _PowerStatCardState extends State<PowerStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(20),
          borderColor: Colors.white.withOpacity(0.2),
          gradientColors: [
            widget.color.withOpacity(0.4),
            widget.color.withOpacity(0.1),
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white.withOpacity(0.9),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

