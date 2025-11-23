import 'package:flutter/material.dart';
import 'glassmorphic_card.dart';
import '../core/design_tokens.dart';

class PowerStatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final double? trend;
  final String? subtitle;
  final VoidCallback? onTap;

  const PowerStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.trend,
    this.subtitle,
    this.onTap,
  });

  @override
  State<PowerStatCard> createState() => _PowerStatCardState();
}

class _PowerStatCardState extends State<PowerStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.color ?? DesignTokens.primary;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: DesignTokens.durationFast,
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(DesignTokens.space16),
          backgroundColor: DesignTokens.surfaceDefault,
          borderColor: _isHovered ? accentColor.withOpacity(0.4) : DesignTokens.borderDefault,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Icon + Trend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.space8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: DesignTokens.borderRadiusSmall,
                    ),
                    child: Icon(
                      widget.icon,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  if (widget.trend != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          DesignTokens.getTrendIcon(widget.trend!),
                          color: DesignTokens.getTrendColor(widget.trend!),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.trend! > 0 ? '+' : ''}${widget.trend!.toStringAsFixed(0)}%',
                          style: DesignTokens.labelSmall.copyWith(
                            color: DesignTokens.getTrendColor(widget.trend!),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              const SizedBox(height: DesignTokens.space12),
              
              // Value
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.value,
                  style: DesignTokens.dataMedium,
                ),
              ),
              
              const SizedBox(height: DesignTokens.space4),
              
              // Label + optional subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: DesignTokens.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: DesignTokens.labelSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

