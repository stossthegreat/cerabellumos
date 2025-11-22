import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/gradient_button.dart';
import '../screens/settings_screen.dart';

class TeacherTab extends StatelessWidget {
  const TeacherTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // BACKGROUND
          Positioned(
            top: -50,
            left: -100,
            child: AnimatedBlob(
              color: const Color(0xFF059669).withOpacity(0.4),
              size: 350,
            ),
          ),
          Positioned(
            bottom: 100,
            right: -100,
            child: AnimatedBlob(
              color: const Color(0xFFDC2626).withOpacity(0.3),
              size: 400,
              duration: const Duration(seconds: 9),
            ),
          ),
          
          // MAIN CONTENT
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 40),
                    _buildNeuralCore(context),
                    const SizedBox(height: 40),
                    _buildCriticalAlerts(context),
                    const SizedBox(height: 40),
                    _buildPowerAnalysis(context),
                    const SizedBox(height: 40),
                    _buildDominationRoadmap(context),
                    const SizedBox(height: 40),
                    _buildActionButtons(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'INTEL',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
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

  Widget _buildNeuralCore(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(32),
      borderColor: const Color(0xFF8B5CF6).withOpacity(0.5),
      gradientColors: [
        const Color(0xFF8B5CF6).withOpacity(0.3),
        const Color(0xFF6D28D9).withOpacity(0.3),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEURAL ANALYSIS ENGINE',
                      style: TextStyle(
                        color: Color(0xFF22D3EE),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ELITE AI INSIGHTS',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.shield,
                color: Color(0xFF8B5CF6),
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Advanced analysis of your learning patterns. I see everything.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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

  Widget _buildPowerAnalysis(BuildContext context) {
    final stats = [
      {
        'label': 'LEARNING VELOCITY',
        'value': '8.7x',
        'colors': [const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
        'icon': '📈',
      },
      {
        'label': 'FOCUS CONSISTENCY',
        'value': '94%',
        'colors': [const Color(0xFF059669), const Color(0xFF22D3EE)],
        'icon': '🎯',
      },
      {
        'label': 'WEAK POINT RATIO',
        'value': '23%',
        'colors': [const Color(0xFFF97316), const Color(0xFFDC2626)],
        'icon': '⚡',
      },
      {
        'label': 'ELITE RANKING',
        'value': 'TOP 8%',
        'colors': [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
        'icon': '👑',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'POWER ANALYSIS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return GlassmorphicCard(
              padding: const EdgeInsets.all(24),
              gradientColors: [
                (stat['colors'] as List<Color>).first.withOpacity(0.2),
                (stat['colors'] as List<Color>).last.withOpacity(0.1),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stat['icon'] as String,
                    style: const TextStyle(fontSize: 32),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat['value'] as String,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: '⚡ START ELITE SESSION',
            onPressed: () {
              // TODO: Implement
            },
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            height: 70,
            shadowColor: const Color(0xFF8B5CF6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GradientButton(
            text: '🔥 BEAST MODE DRILL',
            onPressed: () {
              // TODO: Implement
            },
            gradientColors: const [Color(0xFFDC2626), Color(0xFFEC4899)],
            height: 70,
            shadowColor: const Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }
}

