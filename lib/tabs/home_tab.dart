import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_state.dart';
import '../providers/study_targets_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/power_stat_card.dart';
import '../widgets/mission_card.dart';
import '../widgets/study_target_card.dart';
import '../widgets/add_target_dialog.dart';
import '../screens/settings_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // POWER BACKGROUND
          const Positioned.fill(
            child: _PowerBackground(),
          ),
          
          // MAIN CONTENT
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 40),
                        _buildPowerStats(context),
                        const SizedBox(height: 40),
                        _buildCriticalAlerts(context),
                        const SizedBox(height: 40),
                        _buildTodaysMissions(context),
                        const SizedBox(height: 40),
                        _buildStudyTargets(context),
                        const SizedBox(height: 40),
                        _buildMomentumCards(context),
                        const SizedBox(height: 40),
                        _buildIntensitySlider(context),
                        const SizedBox(height: 40),
                        _buildDominationRoadmap(context),
                        const SizedBox(height: 100), // Space for FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // FLOATING ACTION BUTTON (Bottom-Right)
          Positioned(
            bottom: 120,
            right: 32,
            child: _buildFAB(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appState = context.watch<AppState>();
    final userData = appState.userData;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFFA855F7),
                      Color(0xFFEC4899),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.8),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    userData['avatar'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Name and Level
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ELITE MODE UNLOCKED',
                      style: TextStyle(
                        color: Color(0xFF22D3EE),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData['name'] as String,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LEVEL ${userData['level']} • ${userData['streak']} DAY DOMINATION',
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Settings Icon
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(
            LucideIcons.settings,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPowerStats(BuildContext context) {
    final appState = context.watch<AppState>();
    final userData = appState.userData;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        PowerStatCard(
          label: 'IQ',
          value: '${userData['iq']}',
          icon: LucideIcons.brain,
          color: const Color(0xFF8B5CF6),
        ),
        PowerStatCard(
          label: 'POWER',
          value: '${userData['studyPower']}',
          icon: LucideIcons.zap,
          color: const Color(0xFFDC2626),
        ),
        PowerStatCard(
          label: 'MASTERY',
          value: '${((userData['masteryRate'] as double) * 100).toInt()}%',
          icon: LucideIcons.crown,
          color: const Color(0xFFEC4899),
        ),
        PowerStatCard(
          label: 'STREAK',
          value: '${userData['streak']}',
          icon: LucideIcons.flame,
          color: const Color(0xFFF97316),
        ),
      ],
    );
  }

  Widget _buildCriticalAlerts(BuildContext context) {
    final alerts = [
      {
        'title': 'CHEMISTRY CRISIS',
        'detail': 'Only 5 days. 38% unprepared. URGENT.',
        'icon': '🔴',
      },
      {
        'title': 'MATH WEAKNESS',
        'detail': 'Integration concepts at 40% mastery. Attack now.',
        'icon': '⚠️',
      },
      {
        'title': 'TIME LEAK',
        'detail': 'You\'re losing 3 hours/week to distractions. LOCK IN.',
        'icon': '⏰',
      },
    ];

    return GlassmorphicCard(
      padding: const EdgeInsets.all(24),
      borderColor: const Color(0xFFDC2626).withOpacity(0.6),
      gradientColors: [
        const Color(0xFFDC2626).withOpacity(0.3),
        Colors.transparent,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.bomb,
                color: Color(0xFFF87171),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'CRITICAL ALERTS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF87171),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFDC2626).withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['icon'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFF87171),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert['detail'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w700,
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
      ),
    );
  }

  Widget _buildTodaysMissions(BuildContext context) {
    final appState = context.watch<AppState>();
    final todayPlan = appState.todayPlan;
    final remaining = todayPlan.where((m) => !(m['done'] as bool)).length;

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
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$remaining REMAINING',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
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
    final intensity = appState.intensity;

    return GlassmorphicCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STUDY INTENSITY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                '${intensity.toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 12,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              activeTrackColor: const Color(0xFFDC2626),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: const Color(0xFFDC2626),
              overlayColor: const Color(0xFFDC2626).withOpacity(0.3),
            ),
            child: Slider(
              value: intensity,
              min: 0,
              max: 100,
              onChanged: (value) {
                appState.setIntensity(value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'BEAST MODE ${'▸' * (intensity / 10).ceil()}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDominationRoadmap(BuildContext context) {
    final roadmap = [
      {
        'priority': 1,
        'task': 'CHEMISTRY: Organic Reactions Deep Dive',
        'time': '2h TODAY',
        'impact': 'CRITICAL',
        'energy': '🔥🔥🔥',
      },
      {
        'priority': 2,
        'task': 'MATH: Integration Mastery Session',
        'time': '1.5h TODAY',
        'impact': 'HIGH',
        'energy': '🔥🔥',
      },
      {
        'priority': 3,
        'task': 'BIOLOGY: Photosynthesis Quiz Blitz',
        'time': '45m TOMORROW',
        'impact': 'MEDIUM',
        'energy': '🔥',
      },
    ];

    Color getImpactColor(String impact) {
      switch (impact) {
        case 'CRITICAL':
          return const Color(0xFFDC2626);
        case 'HIGH':
          return const Color(0xFFF97316);
        default:
          return const Color(0xFF3B82F6);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              LucideIcons.eye,
              color: Color(0xFF8B5CF6),
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'DOMINATION ROADMAP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...roadmap.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${item['priority']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['task'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getImpactColor(item['impact'] as String),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['impact'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['time'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                item['energy'] as String,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
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

class _PowerBackground extends StatefulWidget {
  const _PowerBackground();

  @override
  State<_PowerBackground> createState() => _PowerBackgroundState();
}

class _PowerBackgroundState extends State<_PowerBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F172A),
                Colors.black,
                Colors.black,
              ],
            ),
          ),
        ),
        // Top gradient overlay
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF8B5CF6).withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Animated blobs
        AnimatedBlob(
          color: const Color(0xFF8B5CF6).withOpacity(0.4),
          size: 400,
          initialX: -100,
          initialY: -100,
        ),
        AnimatedBlob(
          color: const Color(0xFFDC2626).withOpacity(0.3),
          size: 350,
          initialX: MediaQuery.of(context).size.width - 250,
          initialY: 100,
          duration: const Duration(seconds: 9),
        ),
        AnimatedBlob(
          color: const Color(0xFFEC4899).withOpacity(0.3),
          size: 400,
          initialX: MediaQuery.of(context).size.width / 2 - 200,
          initialY: MediaQuery.of(context).size.height - 300,
          duration: const Duration(seconds: 11),
        ),
        // Grid overlay
        Positioned.fill(
          child: Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEC4899).withOpacity(0.05)
      ..strokeWidth = 1;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

