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
          // Header
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  LucideIcons.brain,
                  color: Color(0xFF8B5CF6),
                  size: 32,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Generated Timestamp
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.clock,
                  color: Colors.grey.shade400,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Generated Today at 07:00 AM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // THREAT ASSESSMENT Section
          _buildIntelSection(
            icon: LucideIcons.alertTriangle,
            iconColor: const Color(0xFFDC2626),
            title: 'THREAT ASSESSMENT',
            content: 'Chemistry exam in 5 days. Current mastery: 62%. Predicted outcome: 72% (C grade). Biology in 12 days looking strong at 78%. Math in 17 days needs urgent attention - only 45% mastery.',
          ),
          
          const SizedBox(height: 24),
          
          // WEAK POINTS Section
          _buildIntelSection(
            icon: LucideIcons.target,
            iconColor: const Color(0xFFF59E0B),
            title: 'WEAK POINTS',
            bulletPoints: [
              'Organic Chemistry reactions - 3 sessions, score still 40%',
              'Calculus integration - avoiding this topic for 1 week',
              'Physics momentum - studied once, scored 35%, never revisited',
            ],
          ),
          
          const SizedBox(height: 24),
          
          // PREDICTIONS Section
          _buildIntelSection(
            icon: LucideIcons.trendingUp,
            iconColor: const Color(0xFF8B5CF6),
            title: 'PREDICTIONS',
            content: 'At current rate: Chemistry 72% (C), Biology 91% (A-), Math 58% (D).\n\nIf you push Chemistry to 2h/day for next 4 days, you can hit 85% (B+). Math needs 6 hours minimum to reach passing grade.',
          ),
          
          const SizedBox(height: 24),
          
          // TODAY'S MISSIONS Section
          _buildIntelSection(
            icon: LucideIcons.listTodo,
            iconColor: const Color(0xFF10B981),
            title: 'TODAY\'S MISSIONS',
            missions: [
              {'time': '09:00', 'subject': 'Chemistry', 'task': 'Organic Reactions Mechanisms (60 min)', 'priority': 'CRITICAL'},
              {'time': '11:00', 'subject': 'Math', 'task': 'Integration Practice Problems (45 min)', 'priority': 'HIGH'},
              {'time': '14:00', 'subject': 'Chemistry', 'task': 'Past Paper Q1-5 (40 min)', 'priority': 'CRITICAL'},
              {'time': '16:00', 'subject': 'Biology', 'task': 'Review Cell Division (30 min)', 'priority': 'LOW'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // BEHAVIORAL INSIGHTS Section
          _buildIntelSection(
            icon: LucideIcons.eye,
            iconColor: const Color(0xFFEC4899),
            title: 'BEHAVIORAL INSIGHTS',
            content: 'You study best 9am-11am (mastery jumps 12% avg) but keep wasting it on YouTube. You say chemistry is priority but studied biology 3x more this week - exam is in 5 DAYS.',
            isWarning: true,
          ),
        ],
      ),
    );
  }

  Widget _buildIntelSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? content,
    List<String>? bulletPoints,
    List<Map<String, String>>? missions,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isWarning 
            ? const Color(0xFFDC2626).withOpacity(0.1)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning 
              ? const Color(0xFFDC2626).withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: isWarning ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: iconColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Content
          if (content != null)
            Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          
          // Bullet Points
          if (bulletPoints != null)
            ...bulletPoints.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          
          // Missions
          if (missions != null)
            ...missions.asMap().entries.map((entry) {
              final index = entry.key;
              final mission = entry.value;
              final priorityColor = mission['priority'] == 'CRITICAL'
                  ? const Color(0xFFDC2626)
                  : mission['priority'] == 'HIGH'
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF10B981);
              
              return Padding(
                padding: EdgeInsets.only(bottom: index < missions.length - 1 ? 12 : 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: priorityColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Time
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          mission['time']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: priorityColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Task details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission['subject']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mission['task']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Priority badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: priorityColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          mission['priority']!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: priorityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
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
              padding: const EdgeInsets.all(16),
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
                    size: 28,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          stat['label'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          stat['value'] as String,
                          style: const TextStyle(
                            fontSize: 24,
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

