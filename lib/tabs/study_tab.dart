import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/gradient_button.dart';
import '../screens/settings_screen.dart';
import '../screens/ai_scanner_screen.dart';
import '../screens/flashcard_turbo_screen.dart';
import '../screens/video_mastery_screen.dart';
import '../screens/deep_dive_screen.dart';

class StudyTab extends StatelessWidget {
  const StudyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // BACKGROUND
          Positioned(
            top: 0,
            right: -100,
            child: AnimatedBlob(
              color: const Color(0xFFEC4899).withOpacity(0.3),
              size: 400,
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
                    _buildPowerToolsList(context),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'POWER TOOLS',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'UNLOAD YOUR POTENTIAL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFDC2626),
                  letterSpacing: 1,
                ),
              ),
            ],
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

  Widget _buildPowerToolsList(BuildContext context) {
    final tools = [
      {
        'name': 'AI SCANNER',
        'desc': 'Point your camera at any problem and get instant step-by-step solutions powered by elite AI',
        'icon': LucideIcons.scanLine,
        'colors': [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
        'screen': const AIScannerScreen(),
        'emoji': '📸',
      },
      {
        'name': 'FLASHCARD TURBO',
        'desc': 'Swipe through smart flashcards with spaced repetition - master anything 10x faster',
        'icon': LucideIcons.layers,
        'colors': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        'screen': const FlashcardTurboScreen(),
        'emoji': '🃏',
      },
      {
        'name': 'VIDEO MASTERY',
        'desc': 'Upload any video and AI extracts key concepts, timestamps, and generates instant quizzes',
        'icon': LucideIcons.video,
        'colors': [const Color(0xFFEC4899), const Color(0xFFBE185D)],
        'screen': const VideoMasteryScreen(),
        'emoji': '🎥',
      },
      {
        'name': 'DEEP DIVE',
        'desc': 'Unlock any concept with interactive knowledge trees - learn everything from first principles',
        'icon': LucideIcons.lightbulb,
        'colors': [const Color(0xFF06B6D4), const Color(0xFF0284C7)],
        'screen': const DeepDiveScreen(),
        'emoji': '💡',
      },
    ];

    return Column(
      children: tools.map((tool) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _PowerToolCard(
            name: tool['name'] as String,
            description: tool['desc'] as String,
            emoji: tool['emoji'] as String,
            icon: tool['icon'] as IconData,
            gradientColors: tool['colors'] as List<Color>,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => tool['screen'] as Widget,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class _PowerToolCard extends StatefulWidget {
  final String name;
  final String description;
  final String emoji;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _PowerToolCard({
    required this.name,
    required this.description,
    required this.emoji,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_PowerToolCard> createState() => _PowerToolCardState();
}

class _PowerToolCardState extends State<_PowerToolCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Shimmer effect
              if (_isHovered)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.1 * _shimmerController.value),
                              Colors.white.withOpacity(0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Emoji + Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            widget.icon,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow
                    Icon(
                      LucideIcons.chevronRight,
                      color: Colors.white.withOpacity(0.6),
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

