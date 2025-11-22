import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'glassmorphic_card.dart';

class MissionCard extends StatelessWidget {
  final String time;
  final String task;
  final String duration;
  final bool done;
  final String priority;
  final int efficiency;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    required this.time,
    required this.task,
    required this.duration,
    required this.done,
    required this.priority,
    required this.efficiency,
    this.onTap,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case 'CRITICAL':
        return const Color(0xFFDC2626);
      case 'ELITE':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      borderColor: done
          ? const Color(0xFF10B981).withOpacity(0.3)
          : const Color(0xFF8B5CF6).withOpacity(0.5),
      gradientColors: done
          ? [
              const Color(0xFF10B981).withOpacity(0.2),
              const Color(0xFF10B981).withOpacity(0.05),
            ]
          : [
              const Color(0xFF8B5CF6).withOpacity(0.2),
              const Color(0xFF8B5CF6).withOpacity(0.05),
            ],
      onTap: onTap,
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: done
                    ? const Color(0xFF10B981)
                    : const Color(0xFF8B5CF6),
                width: 2,
              ),
              color: done ? const Color(0xFF10B981) : Colors.transparent,
              boxShadow: done
                  ? [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.6),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: done
                ? const Icon(
                    LucideIcons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Task Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: done ? Colors.grey.shade500 : Colors.white,
                          decoration:
                              done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        priority,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$time • $duration',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Efficiency (if done)
          if (done) ...[
            const SizedBox(width: 16),
            Text(
              '$efficiency% EFF',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(width: 8),
          Icon(
            LucideIcons.chevronRight,
            color: Colors.grey.shade600,
            size: 20,
          ),
        ],
      ),
    );
  }
}

