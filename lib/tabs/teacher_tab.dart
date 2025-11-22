import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/app_state.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/exam_threat_card.dart';
import '../screens/settings_screen.dart';

class TeacherTab extends StatelessWidget {
  const TeacherTab({super.key});

  // Mock Identity Engine Data
  Map<String, dynamic> get _identityEngine => {
    'archetype': 'Momentum Builder',
    'archetypeIcon': '🚀',
    'confidence': 87,
    'direction': 'Becoming more consistent',
    'directionTrend': 'up', // up, down, stable
    'drivers': [
      'Morning sessions (5-7 AM) with 92% completion',
      'Strong pre-exam preparation (2 weeks ahead)',
      'Consistent 4-day weekly rhythm',
    ],
    'riskTag': 'Safe',
    'currentState': 'Drift Cycler',
    'targetState': 'Momentum Builder',
    'evolutionProgress': 0.65, // 65%
    'lastChange': '3 days ago',
  };

  // Archetype Color Schemes
  List<Color> _getArchetypeColors(String archetype) {
    switch (archetype) {
      case 'Momentum Builder':
        return [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)];
      case 'Drift Cycler':
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      case 'Last-Minute Sprinter':
        return [const Color(0xFFDC2626), const Color(0xFFB91C1C)];
      case 'Consistent Grinder':
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case 'Avoidant Crammer':
        return [const Color(0xFF991B1B), const Color(0xFF7F1D1D)];
      default:
        return [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)];
    }
  }

  Color _getRiskColor(String riskTag) {
    switch (riskTag) {
      case 'Safe':
        return const Color(0xFF10B981);
      case 'At Risk':
        return const Color(0xFFF59E0B);
      case 'Red Zone Before Exam':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF10B981);
    }
  }

  IconData _getDirectionIcon(String trend) {
    switch (trend) {
      case 'up':
        return LucideIcons.trendingUp;
      case 'down':
        return LucideIcons.trendingDown;
      default:
        return LucideIcons.minus;
    }
  }

  Color _getDirectionColor(String trend) {
    switch (trend) {
      case 'up':
        return const Color(0xFF10B981);
      case 'down':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFF59E0B);
    }
  }

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
                    _buildIdentityEngine(context),
                    const SizedBox(height: 40),
                    _buildStudyArchive(context),
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

  Widget _buildIdentityEngine(BuildContext context) {
    final identity = _identityEngine;
    final archetypeColors = _getArchetypeColors(identity['archetype'] as String);
    final riskColor = _getRiskColor(identity['riskTag'] as String);
    final directionIcon = _getDirectionIcon(identity['directionTrend'] as String);
    final directionColor = _getDirectionColor(identity['directionTrend'] as String);
    
    return GlassmorphicCard(
      padding: const EdgeInsets.all(32),
      borderColor: archetypeColors.first.withOpacity(0.6),
      gradientColors: [
        archetypeColors.first.withOpacity(0.4),
        archetypeColors.last.withOpacity(0.2),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'IDENTITY ENGINE',
                style: TextStyle(
                  color: archetypeColors.first,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: riskColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.shield,
                      color: riskColor,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      identity['riskTag'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Current Archetype (Hero)
          Center(
            child: Column(
              children: [
                Text(
                  identity['archetypeIcon'] as String,
                  style: const TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  identity['archetype'] as String,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Confidence Level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CONFIDENCE',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '${identity['confidence']}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: archetypeColors.first,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (identity['confidence'] as int) / 100,
                  minHeight: 12,
                  backgroundColor: Colors.black.withOpacity(0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(archetypeColors.first),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Direction of Change
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: directionColor.withOpacity(0.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: directionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    directionIcon,
                    color: directionColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRAJECTORY',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        identity['direction'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: directionColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Dominant Drivers
          Text(
            'DOMINANT PATTERNS',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          ...(identity['drivers'] as List<String>).map((driver) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: archetypeColors.first,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    driver,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 32),
          
          // Evolution Path
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  archetypeColors.first.withOpacity(0.3),
                  archetypeColors.last.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: archetypeColors.first.withOpacity(0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVOLUTION PATH',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FROM',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            identity['currentState'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.arrowRight,
                      color: archetypeColors.first,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TO',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            identity['targetState'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: archetypeColors.first,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: identity['evolutionProgress'] as double,
                    minHeight: 8,
                    backgroundColor: Colors.black.withOpacity(0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(archetypeColors.first),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((identity['evolutionProgress'] as double) * 100).toInt()}% Complete',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyArchive(BuildContext context) {
    final archiveStats = [
      {
        'label': 'TOTAL STUDY HOURS',
        'value': '247h',
        'icon': LucideIcons.clock,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'label': 'PEAK STREAK',
        'value': '28 Days',
        'icon': LucideIcons.flame,
        'color': const Color(0xFFF97316),
      },
      {
        'label': 'SESSIONS COMPLETED',
        'value': '186',
        'icon': LucideIcons.checkCircle,
        'color': const Color(0xFF10B981),
      },
      {
        'label': 'CONCEPTS MASTERED',
        'value': '142',
        'icon': LucideIcons.brain,
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.database,
              color: Color(0xFF22D3EE),
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'STUDY ARCHIVE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
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
          itemCount: archiveStats.length,
          itemBuilder: (context, index) {
            final stat = archiveStats[index];
            return GlassmorphicCard(
              padding: const EdgeInsets.all(20),
              gradientColors: [
                (stat['color'] as Color).withOpacity(0.2),
                (stat['color'] as Color).withOpacity(0.05),
              ],
              borderColor: (stat['color'] as Color).withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 32,
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
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
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

}

