import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/study_targets_provider.dart';
import 'glassmorphic_card.dart';

class StudyTargetCard extends StatefulWidget {
  final StudyTarget target;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const StudyTargetCard({
    super.key,
    required this.target,
    required this.onToggle,
    this.onDelete,
  });

  @override
  State<StudyTargetCard> createState() => _StudyTargetCardState();
}

class _StudyTargetCardState extends State<StudyTargetCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getThreatLevel() {
    final days = widget.target.daysRemaining;
    if (days <= 5) return 'CRITICAL';
    if (days <= 14) return 'HIGH';
    return 'MEDIUM';
  }

  Color _getThreatColor() {
    final level = _getThreatLevel();
    switch (level) {
      case 'CRITICAL':
        return const Color(0xFFDC2626);
      case 'HIGH':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final threatColor = _getThreatColor();
    final daysRemaining = widget.target.daysRemaining;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            borderColor: widget.target.isCompleted
                ? const Color(0xFF10B981).withOpacity(0.5)
                : threatColor.withOpacity(0.5),
            gradientColors: widget.target.isCompleted
                ? [
                    const Color(0xFF10B981).withOpacity(0.2),
                    const Color(0xFF10B981).withOpacity(0.05),
                  ]
                : [
                    threatColor.withOpacity(0.2),
                    threatColor.withOpacity(0.1),
                  ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: widget.onToggle,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.target.isCompleted
                                ? const Color(0xFF10B981)
                                : threatColor,
                            width: 2,
                          ),
                          color: widget.target.isCompleted
                              ? const Color(0xFF10B981)
                              : Colors.transparent,
                          boxShadow: widget.target.isCompleted
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.6),
                                    blurRadius: 12,
                                  ),
                                ]
                              : [],
                        ),
                        child: widget.target.isCompleted
                            ? const Icon(
                                LucideIcons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Emoji
                    Text(
                      widget.target.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.target.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: widget.target.isCompleted
                                  ? Colors.grey.shade500
                                  : Colors.white,
                              decoration: widget.target.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (widget.target.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.target.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Days Remaining Badge
                    if (!widget.target.isCompleted) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: threatColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$daysRemaining DAYS',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    // Delete Button
                    if (widget.onDelete != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(
                          LucideIcons.trash2,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROGRESS',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '${(widget.target.progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: widget.target.isCompleted
                                ? const Color(0xFF10B981)
                                : threatColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.target.progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.target.isCompleted
                                  ? [
                                      const Color(0xFF10B981),
                                      const Color(0xFF059669),
                                    ]
                                  : [threatColor, threatColor.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

