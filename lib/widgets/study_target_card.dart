import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/study_targets_provider.dart';
import '../core/design_tokens.dart';
import 'glassmorphic_card.dart';

class StudyTargetCard extends StatelessWidget {
  final StudyTarget target;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const StudyTargetCard({
    super.key,
    required this.target,
    required this.onToggle,
    this.onDelete,
  });

  Color _getStatusColor() {
    if (target.isCompleted) return DesignTokens.success;
    final days = target.daysRemaining;
    if (days <= 3) return DesignTokens.error;
    if (days <= 7) return DesignTokens.warning;
    return DesignTokens.primary;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return GlassmorphicCard(
      padding: const EdgeInsets.all(DesignTokens.space16),
      borderColor: statusColor.withOpacity(0.3),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor,
                  width: 2,
                ),
                color: target.isCompleted ? statusColor : Colors.transparent,
              ),
              child: target.isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: DesignTokens.space12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      target.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        target.title,
                        style: DesignTokens.heading3.copyWith(
                          color: target.isCompleted
                              ? DesignTokens.textTertiary
                              : DesignTokens.textPrimary,
                          decoration: target.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                if (target.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    target.description,
                    style: DesignTokens.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: DesignTokens.space8),
                
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: target.progress,
                    minHeight: 6,
                    backgroundColor: DesignTokens.borderDefault,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: DesignTokens.space12),
          
          // Days badge + delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!target.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${target.daysRemaining}d',
                    style: DesignTokens.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              
              if (onDelete != null) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    LucideIcons.trash2,
                    color: DesignTokens.textTertiary,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
