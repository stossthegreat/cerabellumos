// lib/widgets/coaching_message_card.dart
// 🎯 Smart Coaching Message Card - Actionable Intelligence UI

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/design_tokens.dart';
import '../models/coaching_message.dart';
import '../widgets/glassmorphic_card.dart';
import '../services/api_service.dart';

class CoachingMessageCard extends StatelessWidget {
  final CoachingMessage message;
  final VoidCallback? onDismiss;

  const CoachingMessageCard({
    super.key,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(DesignTokens.space20),
      borderColor: _getPriorityColor(message.priority).withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.space12),
                decoration: BoxDecoration(
                  color: _getPriorityColor(message.priority).withOpacity(0.15),
                  borderRadius: DesignTokens.borderRadiusSmall,
                ),
                child: Icon(
                  _getTypeIcon(message.type),
                  color: _getPriorityColor(message.priority),
                  size: 24,
                ),
              ),
              const SizedBox(width: DesignTokens.space16),
              Expanded(
                child: Text(
                  message.title,
                  style: DesignTokens.heading3,
                ),
              ),
              // Dismiss button
              IconButton(
                icon: const Icon(LucideIcons.x, size: 18),
                color: DesignTokens.textTertiary,
                onPressed: () async {
                  await ApiService.dismissCoachingMessage(message.id);
                  onDismiss?.call();
                },
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space16),

          // Weak Areas (if exam prep)
          if (message.weakAreas != null && message.weakAreas!.isNotEmpty) ...[
            Text('Weak Areas:', style: DesignTokens.labelMedium),
            const SizedBox(height: DesignTokens.space8),
            ...message.weakAreas!.map((area) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text('• ${area.topic}', style: DesignTokens.bodyMedium),
                  const SizedBox(width: DesignTokens.space8),
                  Text(
                    '(${area.mastery}%)',
                    style: DesignTokens.labelSmall.copyWith(
                      color: DesignTokens.getMasteryColor(area.mastery.toDouble()),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: DesignTokens.space16),
          ],

          // Context Info (for drift recovery, momentum, etc.)
          if (message.context != null && message.context!.isNotEmpty) ...[
            _buildContextInfo(message.context!),
            const SizedBox(height: DesignTokens.space16),
          ],

          // Smart Plan
          Container(
            padding: const EdgeInsets.all(DesignTokens.space16),
            decoration: BoxDecoration(
              color: DesignTokens.backgroundTertiary,
              borderRadius: DesignTokens.borderRadiusSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SMART PLAN:', style: DesignTokens.labelSmall),
                const SizedBox(height: DesignTokens.space8),
                Text(
                  message.plan.description,
                  style: DesignTokens.bodyMedium,
                ),
                if (message.plan.predictedGain != null) ...[
                  const SizedBox(height: DesignTokens.space8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.trendingUp,
                        size: 14,
                        color: DesignTokens.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${message.plan.predictedGain}% mastery boost',
                        style: DesignTokens.labelMedium.copyWith(
                          color: DesignTokens.success,
                        ),
                      ),
                    ],
                  ),
                ],
                if (message.plan.breakdown != null) ...[
                  const SizedBox(height: DesignTokens.space12),
                  ...message.plan.breakdown!.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $step',
                      style: DesignTokens.bodySmall,
                    ),
                  )),
                ],
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.space16),

          // Action Buttons
          Wrap(
            spacing: DesignTokens.space8,
            runSpacing: DesignTokens.space8,
            children: message.actions.map((action) => 
              ElevatedButton.icon(
                onPressed: () => _handleAction(context, action),
                icon: Icon(_getActionIcon(action.type), size: 18),
                label: Text(action.label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.primary.withOpacity(0.15),
                  foregroundColor: DesignTokens.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space16,
                    vertical: DesignTokens.space12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: DesignTokens.borderRadiusSmall,
                  ),
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContextInfo(Map<String, dynamic> context) {
    final entries = context.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.map((entry) {
        final key = _formatContextKey(entry.key);
        final value = entry.value.toString();
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Text('$key:', style: DesignTokens.labelSmall),
              const SizedBox(width: 8),
              Text(value, style: DesignTokens.bodySmall.copyWith(
                color: DesignTokens.textSecondary,
              )),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatContextKey(String key) {
    // Convert camelCase to Title Case
    return key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  void _handleAction(BuildContext context, CoachingAction action) async {
    // Mark message as completed
    await ApiService.completeCoachingAction(message.id, action.type);

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${action.label}...'),
        duration: const Duration(seconds: 1),
        backgroundColor: DesignTokens.primary,
      ),
    );

    // Navigate based on action type
    switch (action.type) {
      case 'flashcards':
        // TODO: Navigate to Flashcard screen with pre-loaded topics
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening flashcards for ${action.payload['topics']?.join(', ') ?? 'topics'}...'),
            backgroundColor: DesignTokens.success,
          ),
        );
        break;

      case 'quiz':
        // TODO: Navigate to Quiz screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Quiz feature coming soon!'),
            backgroundColor: DesignTokens.info,
          ),
        );
        break;

      case 'deep_dive':
        // TODO: Navigate to Deep Dive screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deep dive on ${action.payload['topic']} coming soon!'),
            backgroundColor: DesignTokens.info,
          ),
        );
        break;

      case 'scan':
        // TODO: Navigate to Scanner screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Opening AI Scanner...'),
            backgroundColor: DesignTokens.info,
          ),
        );
        break;

      case 'video':
        // TODO: Navigate to Video Mastery screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Video mastery coming soon!'),
            backgroundColor: DesignTokens.info,
          ),
        );
        break;

      case 'quick_review':
        // TODO: Start quick review session
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Starting ${action.payload['duration']} min review...'),
            backgroundColor: DesignTokens.success,
          ),
        );
        break;

      case 'micro_session':
        // TODO: Start micro session
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Starting 5-min session...'),
            backgroundColor: DesignTokens.success,
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action: ${action.label}'),
            backgroundColor: DesignTokens.primary,
          ),
        );
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return DesignTokens.error;
      case 'medium':
        return DesignTokens.warning;
      default:
        return DesignTokens.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'exam_prep':
        return LucideIcons.target;
      case 'drift_recovery':
        return LucideIcons.alertTriangle;
      case 'momentum':
        return LucideIcons.zap;
      case 'consistency':
        return LucideIcons.trendingUp;
      default:
        return LucideIcons.lightbulb;
    }
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'flashcards':
        return LucideIcons.layers;
      case 'quiz':
        return LucideIcons.checkSquare;
      case 'deep_dive':
        return LucideIcons.bookOpen;
      case 'scan':
        return LucideIcons.scan;
      case 'video':
        return LucideIcons.playCircle;
      case 'quick_review':
        return LucideIcons.clock;
      case 'micro_session':
        return LucideIcons.clock;
      default:
        return LucideIcons.arrowRight;
    }
  }
}

