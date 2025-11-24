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
import '../screens/companion_debug_screen.dart';
import '../companion/companion_state.dart';
import '../companion/companion_emotion_engine.dart';
import '../companion/companion_widget.dart';

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
                    _buildCompanion(context),
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
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('EEE, MMM d').format(now).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(DesignTokens.space20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignTokens.primary.withOpacity(0.12),
            DesignTokens.primary.withOpacity(0.04),
          ],
        ),
        borderRadius: DesignTokens.borderRadiusMedium,
        border: Border.all(
          color: DesignTokens.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: title + settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MISSION CONTROL',
                      style: DesignTokens.labelLarge.copyWith(
                        color: DesignTokens.primary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: DesignTokens.space4),
                    Text(
                      'Command Dashboard',
                      style: DesignTokens.displayLarge.copyWith(
                        fontSize: 28,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: DesignTokens.backgroundPrimary.withOpacity(0.6),
                  borderRadius: DesignTokens.borderRadiusSmall,
                ),
                child: IconButton(
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
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: DesignTokens.space16),
          
          // Bottom row: date/time + streak
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: DesignTokens.backgroundPrimary.withOpacity(0.6),
                      borderRadius: DesignTokens.borderRadiusSmall,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          color: DesignTokens.textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeStr,
                          style: DesignTokens.labelSmall.copyWith(
                            color: DesignTokens.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: DesignTokens.labelSmall.copyWith(
                      color: DesignTokens.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.warning.withOpacity(0.15),
                  borderRadius: DesignTokens.borderRadiusSmall,
                  border: Border.all(
                    color: DesignTokens.warning.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      color: DesignTokens.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${userData['streak']}',
                      style: DesignTokens.labelMedium.copyWith(
                        color: DesignTokens.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanion(BuildContext context) {
    final appState = context.watch<AppState>();
    final targetsProvider = context.watch<StudyTargetsProvider>();
    
    final emotion = CompanionEmotionEngine.analyze(
      streak: appState.userData['streak'] as int,
      todayMinutes: appState.userData['todayMinutes'] as int,
      exams: appState.exams,
      hour: DateTime.now().hour,
      targets: targetsProvider.targets,
    );
    
    return GestureDetector(
      onLongPress: () {
        // Long press to open debug screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CompanionDebugScreen(),
          ),
        );
      },
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(DesignTokens.space24),
        child: Column(
          children: [
            CompanionWidget(
              emotion: emotion,
              size: 140,
            ),
            const SizedBox(height: DesignTokens.space16),
            Text(
              emotion.reason,
              style: DesignTokens.bodyMedium.copyWith(
                color: DesignTokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.space8),
            Text(
              _getStateLabel(emotion.state),
              style: DesignTokens.labelSmall.copyWith(
                color: DesignTokens.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStateLabel(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return 'Ready';
      case CompanionState.focused:
        return 'Focused';
      case CompanionState.alert:
        return 'Alert';
      case CompanionState.proud:
        return 'Proud';
      case CompanionState.disappointed:
        return 'Needs attention';
      case CompanionState.curious:
        return 'Curious';
      case CompanionState.sleeping:
        return 'Resting';
    }
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
        'detail': 'Exam in 4 days — Study deficit: 8.8 hrs',
        'risk': 85.0,
        'icon': LucideIcons.alertTriangle,
      },
      {
        'subject': 'Mathematics',
        'detail': 'Integration mastery: 42% — Need 12.5 hrs',
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
            padding: const EdgeInsets.all(DesignTokens.space16),
            borderColor: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.15),
                    borderRadius: DesignTokens.borderRadiusSmall,
                  ),
                  child: Icon(
                    alert['icon'] as IconData,
                    color: DesignTokens.getRiskColor(alert['risk'] as double),
                    size: 20,
                  ),
                ),
                const SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              alert['subject'] as String,
                              style: DesignTokens.heading3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: DesignTokens.space8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: DesignTokens.getRiskColor(alert['risk'] as double).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(alert['risk'] as double).toInt()}%',
                              style: DesignTokens.labelSmall.copyWith(
                                color: DesignTokens.getRiskColor(alert['risk'] as double),
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        alert['detail'] as String,
                        style: DesignTokens.bodySmall.copyWith(
                          color: DesignTokens.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

    if (todayPlan.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Missions",
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        ...todayPlan.map((mission) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.space12),
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
        Text(
          'Study Targets',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        ...targets.map((target) => Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.space12),
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
        Text(
          'Active Projects',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        Row(
          children: pinnedProjects.map((project) {
            final isPositive = project.momentum.contains('+');
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: DesignTokens.space12),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(DesignTokens.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            project.emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? DesignTokens.success
                                  : DesignTokens.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              project.momentum,
                              style: DesignTokens.labelSmall.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: DesignTokens.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: DesignTokens.space12),
                      Text(
                        project.name,
                        style: DesignTokens.heading3.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: DesignTokens.space12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score',
                                style: DesignTokens.labelSmall.copyWith(
                                  fontSize: 9,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${project.power}',
                                style: DesignTokens.dataMedium.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            LucideIcons.zap,
                            color: DesignTokens.warning,
                            size: 20,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Target',
          style: DesignTokens.heading1,
        ),
        const SizedBox(height: DesignTokens.space16),
        const _WeeklyTargetCard(),
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

// Isolated widget for Weekly Target to prevent page jumping when slider moves
class _WeeklyTargetCard extends StatelessWidget {
  const _WeeklyTargetCard();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final targetHours = appState.intensity;

    return GlassmorphicCard(
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
    );
  }
}

