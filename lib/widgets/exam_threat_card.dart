import 'package:flutter/material.dart';
import 'glassmorphic_card.dart';

class ExamThreatCard extends StatefulWidget {
  final String subject;
  final String icon;
  final String date;
  final int days;
  final String threat;
  final List<String> gradientColors;
  final int progress;
  final String prediction;

  const ExamThreatCard({
    super.key,
    required this.subject,
    required this.icon,
    required this.date,
    required this.days,
    required this.threat,
    required this.gradientColors,
    required this.progress,
    required this.prediction,
  });

  @override
  State<ExamThreatCard> createState() => _ExamThreatCardState();
}

class _ExamThreatCardState extends State<ExamThreatCard> {
  bool _isHovered = false;

  Color _getThreatColor() {
    switch (widget.threat) {
      case 'CRITICAL':
        return const Color(0xFFDC2626);
      case 'HIGH':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  List<Color> _getGradientColors() {
    return widget.gradientColors
        .map((hex) => Color(int.parse(hex.replaceFirst('#', '0xFF'))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final threatColor = _getThreatColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(16),
          borderColor: Colors.white.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon, Subject, Threat Badge
              Row(
                children: [
                  Text(
                    widget.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.subject,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: threatColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.threat,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${widget.date} • ${widget.days} DAYS LEFT',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Prediction
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'PREDICTION',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.prediction,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PREPARATION',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${widget.progress}%',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: widget.progress < 50
                              ? const Color(0xFFF87171)
                              : widget.progress < 75
                                  ? const Color(0xFFFB923C)
                                  : const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.progress / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(3),
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
    );
  }
}

