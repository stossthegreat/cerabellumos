import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/design_tokens.dart';
import '../widgets/glassmorphic_card.dart';
import '../screens/settings_screen.dart';

class TeacherTab extends StatelessWidget {
  const TeacherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.space24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: DesignTokens.space32),
                _buildStats(context),
                const SizedBox(height: DesignTokens.space32),
                _buildIdentity(context),
                const SizedBox(height: DesignTokens.space32),
                _buildIntelligence(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Intelligence Dashboard',
          style: DesignTokens.displayLarge,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(
            LucideIcons.settings,
            color: DesignTokens.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: DesignTokens.space16,
      mainAxisSpacing: DesignTokens.space16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard('Study Hours', '127.5', LucideIcons.clock, DesignTokens.primary),
        _buildStatCard('Peak Streak', '28 days', LucideIcons.flame, DesignTokens.warning),
        _buildStatCard('Sessions', '186', LucideIcons.checkCircle, DesignTokens.success),
        _buildStatCard('Mastery', '68%', LucideIcons.brain, DesignTokens.info),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(DesignTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: DesignTokens.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '+12%',
                  style: DesignTokens.labelSmall.copyWith(
                    color: DesignTokens.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: DesignTokens.dataLarge.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: DesignTokens.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Identity',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        GlassmorphicCard(
          padding: const EdgeInsets.all(DesignTokens.space24),
          child: Column(
            children: [
              Text(
                '🎯',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: DesignTokens.space16),
              Text(
                'Consistent Achiever',
                style: DesignTokens.displayMedium.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DesignTokens.space8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: DesignTokens.success.withOpacity(0.2),
                  borderRadius: DesignTokens.borderRadiusSmall,
                ),
                child: Text(
                  'Low Risk • 87% Confidence',
                  style: DesignTokens.labelMedium.copyWith(
                    color: DesignTokens.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.space24),
              _buildIdentityMetric('Direction', 'Increasing consistency', LucideIcons.trendingUp, DesignTokens.success),
              const SizedBox(height: DesignTokens.space12),
              _buildIdentityMetric('Peak Time', 'Mornings 5-7 AM (92% rate)', LucideIcons.clock, DesignTokens.primary),
              const SizedBox(height: DesignTokens.space12),
              _buildIdentityMetric('Rhythm', '4.2 sessions/week sustained', LucideIcons.activity, DesignTokens.info),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityMetric(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: DesignTokens.borderRadiusSmall,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: DesignTokens.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: DesignTokens.labelSmall),
              Text(value, style: DesignTokens.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligence(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intelligence Briefing',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        _buildIntelCard(
          'Threat Assessment',
          'Chemistry exam in 5 days. Current mastery: 62%. Predicted outcome: 72% (C grade).',
          LucideIcons.alertTriangle,
          DesignTokens.error,
        ),
        const SizedBox(height: DesignTokens.space12),
        _buildIntelCard(
          'Predictions',
          'At current rate: Chemistry 72%, Biology 91%, Math 58%. Push Chemistry 2h/day to hit 85%.',
          LucideIcons.trendingUp,
          DesignTokens.primary,
        ),
        const SizedBox(height: DesignTokens.space12),
        _buildIntelCard(
          'Behavioral Insight',
          'You study best 9-11 AM (mastery jumps 12% avg) but keep wasting it. Chemistry exam in 5 days.',
          LucideIcons.eye,
          DesignTokens.warning,
        ),
      ],
    );
  }

  Widget _buildIntelCard(String title, String content, IconData icon, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(DesignTokens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: DesignTokens.borderRadiusSmall,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: DesignTokens.heading3),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: DesignTokens.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

