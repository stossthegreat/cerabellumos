import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../providers/study_targets_provider.dart';
import '../providers/projects_provider.dart';
import '../core/design_tokens.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/power_stat_card.dart';
import '../widgets/mission_card.dart';
import '../widgets/study_target_card.dart';
import '../widgets/add_target_dialog.dart';
import '../widgets/coaching_message_card.dart';
import '../models/coaching_message.dart';
import '../services/api_service.dart';
import '../screens/settings_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(DesignTokens.space24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildAICoach(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildPowerStats(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildCriticalAlerts(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildTodaysMissions(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildStudyTargets(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildMomentumCards(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildIntensitySlider(context),
                    const SizedBox(height: DesignTokens.space32),
                    _buildDominationRoadmap(context),
                    const SizedBox(height: 120), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appState = context.watch<AppState>();
    final userData = appState.userData;
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mission Control',
                    style: DesignTokens.displayLarge,
                  ),
                  const SizedBox(height: DesignTokens.space4),
                  Text(
                    dateStr,
                    style: DesignTokens.labelMedium,
                  ),
                ],
              ),
            ),
            // Streak badge + settings
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space16,
                    vertical: DesignTokens.space8,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.primary.withOpacity(0.15),
                    borderRadius: DesignTokens.borderRadiusSmall,
                    border: Border.all(
                      color: DesignTokens.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.flame,
                        color: DesignTokens.primary,
                        size: 18,
                      ),
                      const SizedBox(width: DesignTokens.space8),
                      Text(
                        '${userData['streak']} day streak',
                        style: DesignTokens.labelMedium.copyWith(
                          color: DesignTokens.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DesignTokens.space12),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAICoach(BuildContext context) {
    return FutureBuilder<List<CoachingMessage>>(
      future: ApiService.getCoachingMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Coach', style: DesignTokens.heading1),
              const SizedBox(height: DesignTokens.space16),
              Center(
                child: CircularProgressIndicator(color: DesignTokens.primary),
              ),
            ],
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Coach', style: DesignTokens.heading1),
              const SizedBox(height: DesignTokens.space16),
              GlassmorphicCard(
                padding: const EdgeInsets.all(DesignTokens.space24),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      color: DesignTokens.primary,
                      size: 48,
                    ),
                    const SizedBox(height: DesignTokens.space16),
                    Text(
                      'No active coaching messages',
                      style: DesignTokens.heading3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.space8),
                    Text(
                      'The AI is analyzing your study patterns.\nCheck back soon for personalized guidance.',
                      style: DesignTokens.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.space16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ApiService.generateCoachingMessages();
                        // Rebuild the widget to fetch new messages
                        (context as Element).markNeedsBuild();
                      },
                      icon: const Icon(LucideIcons.refreshCw, size: 18),
                      label: const Text('Generate Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DesignTokens.primary.withOpacity(0.15),
                        foregroundColor: DesignTokens.primary,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        final messages = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI Coach', style: DesignTokens.heading1),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.primary.withOpacity(0.15),
                    borderRadius: DesignTokens.borderRadiusSmall,
                  ),
                  child: Text(
                    '${messages.length} active',
                    style: DesignTokens.labelSmall.copyWith(
                      color: DesignTokens.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.space16),
            ...messages.map((msg) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.space16),
              child: CoachingMessageCard(
                message: msg,
                onDismiss: () {
                  // Rebuild to remove dismissed message
                  (context as Element).markNeedsBuild();
                },
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildPowerStats(BuildContext context) {
    final stats = [
      {
        'label': 'Study Hours',
        'value': '23.4 / 40',
        'subtitle': 'Weekly target',
        'icon': LucideIcons.clock,
        'color': DesignTokens.primary,
        'trend': -8.0,
      },
      {
        'label': 'Active Streak',
        'value': '12 days',
        'subtitle': 'Peak: 28 days',
        'icon': LucideIcons.flame,
        'color': DesignTokens.warning,
        'trend': 0.0,
      },
      {
        'label': 'Sessions',
        'value': '186',
        'subtitle': 'Completed',
        'icon': LucideIcons.checkCircle,
        'color': DesignTokens.success,
        'trend': 12.0,
      },
      {
        'label': 'Mastery',
        'value': '68%',
        'subtitle': 'Avg across topics',
        'icon': LucideIcons.brain,
        'color': DesignTokens.info,
        'trend': 5.0,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignTokens.space16,
        mainAxisSpacing: DesignTokens.space16,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return PowerStatCard(
          label: stat['label'] as String,
          value: stat['value'] as String,
          subtitle: stat['subtitle'] as String?,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
          trend: stat['trend'] as double?,
        );
      },
    );
  }

  Widget _buildCriticalAlerts(BuildContext context) {
    final alerts = [
      {
        'subject': 'Chemistry',
        'detail': 'Exam in 4 days — 8.8 hrs study deficit — Pass probability: 67%',
        'risk': 85.0,
        'icon': LucideIcons.alertTriangle,
      },
      {
        'subject': 'Mathematics',
        'detail': 'Integration mastery: 42% — 12.5 hrs needed for target',
        'risk': 65.0,
        'icon': LucideIcons.trendingDown,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Critical Alerts',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        ...alerts.map((alert) => Padding(
          padding: const EdgeInsets.only(bottom: DesignTokens.space12),
          child: GlassmorphicCard(
            padding: const EdgeInsets.all(DesignTokens.space20),
            borderColor: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(DesignTokens.space12),
                  decoration: BoxDecoration(
                    color: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.15),
                    borderRadius: DesignTokens.borderRadiusSmall,
                  ),
                  child: Icon(
                    alert['icon'] as IconData,
                    color: DesignTokens.getRiskColor(alert['risk'] as double),
                    size: 24,
                  ),
                ),
                const SizedBox(width: DesignTokens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            alert['subject'] as String,
                            style: DesignTokens.heading3,
                          ),
                          const SizedBox(width: DesignTokens.space8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DesignTokens.space8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(alert['risk'] as double).toInt()}% risk',
                              style: DesignTokens.labelSmall.copyWith(
                                color: DesignTokens.getRiskColor(alert['risk'] as double),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.space8),
                      Text(
                        alert['detail'] as String,
                        style: DesignTokens.bodySmall.copyWith(
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildTodaysMissions(BuildContext context) {
    final appState = context.watch<AppState>();
    final todayPlan = appState.todayPlan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.target,
              color: Color(0xFF8B5CF6),
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'TODAY\'S MISSIONS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...todayPlan.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MissionCard(
                time: mission['time'] as String,
                task: mission['task'] as String,
                duration: mission['duration'] as String,
                done: mission['done'] as bool,
                priority: mission['priority'] as String,
                efficiency: mission['efficiency'] as int,
              ),
            )),
      ],
    );
  }

  Widget _buildStudyTargets(BuildContext context) {
    final targetsProvider = context.watch<StudyTargetsProvider>();
    final targets = targetsProvider.activeTargets;

    if (targets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              LucideIcons.target,
              color: Color(0xFFEC4899),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'STUDY TARGETS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...targets.map((target) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StudyTargetCard(
                target: target,
                onToggle: () {
                  targetsProvider.toggleComplete(target.id);
                },
                onDelete: () {
                  targetsProvider.deleteTarget(target.id);
                },
              ),
            )),
      ],
    );
  }

  Widget _buildMomentumCards(BuildContext context) {
    final projectsProvider = context.watch<ProjectsProvider>();
    final pinnedProjects = projectsProvider.pinnedProjects.take(3).toList();

    if (pinnedProjects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              LucideIcons.trendingUp,
              color: Color(0xFF22D3EE),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'MOMENTUM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: pinnedProjects.map((project) {
            final isPositive = project.momentum.contains('+');
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            project.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              project.momentum,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'POWER',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${project.power}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            LucideIcons.zap,
                            color: Color(0xFFFACC15),
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIntensitySlider(BuildContext context) {
    final appState = context.watch<AppState>();
    final targetHours = appState.intensity; // Using existing intensity as target

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Target',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        GlassmorphicCard(
          padding: const EdgeInsets.all(DesignTokens.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Study Hours',
                        style: DesignTokens.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '23.4 / ${targetHours.toInt()}h',
                        style: DesignTokens.dataMedium,
                      ),
                    ],
                  ),
                  Text(
                    '${((23.4 / targetHours) * 100).toInt()}%',
                    style: DesignTokens.dataLarge.copyWith(
                      color: DesignTokens.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DesignTokens.space16),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  activeTrackColor: DesignTokens.primary,
                  inactiveTrackColor: DesignTokens.borderDefault,
                  thumbColor: DesignTokens.primary,
                  overlayColor: DesignTokens.primary.withOpacity(0.2),
                ),
                child: Slider(
                  value: targetHours,
                  min: 10,
                  max: 60,
                  divisions: 50,
                  label: '${targetHours.toInt()}h target',
                  onChanged: (value) {
                    appState.setIntensity(value);
                  },
                ),
              ),
              const SizedBox(height: DesignTokens.space12),
              Text(
                'Adjust your weekly study target',
                style: DesignTokens.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDominationRoadmap(BuildContext context) {
    final goals = [
      {
        'subject': 'Chemistry',
        'task': 'Master organic reactions',
        'progress': 0.45,
        'eta': '2.5 hrs remaining',
        'priority': 'High',
      },
      {
        'subject': 'Mathematics',
        'task': 'Complete integration practice',
        'progress': 0.68,
        'eta': '1.2 hrs remaining',
        'priority': 'Medium',
      },
      {
        'subject': 'Biology',
        'task': 'Cellular respiration review',
        'progress': 0.22,
        'eta': '3.8 hrs remaining',
        'priority': 'Low',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Trajectory',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        ...goals.map((goal) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.space12),
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(DesignTokens.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goal['subject'] as String,
                                style: DesignTokens.heading3,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                goal['task'] as String,
                                style: DesignTokens.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${((goal['progress'] as double) * 100).toInt()}%',
                          style: DesignTokens.dataMedium.copyWith(
                            color: DesignTokens.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.space12),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: DesignTokens.backgroundTertiary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: goal['progress'] as double,
                        child: Container(
                          decoration: BoxDecoration(
                            color: DesignTokens.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space8),
                    Text(
                      goal['eta'] as String,
                      style: DesignTokens.labelSmall,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const AddTargetDialog(),
        );
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(
          LucideIcons.plus,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}


