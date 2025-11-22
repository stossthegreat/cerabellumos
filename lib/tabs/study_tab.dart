import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/animated_blob.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/gradient_button.dart';
import '../screens/settings_screen.dart';

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
                    _buildPowerToolsGrid(context),
                    const SizedBox(height: 32),
                    _buildInstantPhotoSolve(context),
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

  Widget _buildPowerToolsGrid(BuildContext context) {
    final tools = [
      {
        'name': 'AI SCANNER',
        'desc': 'INSTANT ANSWERS',
        'icon': LucideIcons.scanLine,
        'colors': [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
      },
      {
        'name': 'FLASHCARD TURBO',
        'desc': 'RAPID MEMORIZE',
        'icon': LucideIcons.layers,
        'colors': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
      },
      {
        'name': 'VIDEO MASTERY',
        'desc': 'WATCH & ABSORB',
        'icon': LucideIcons.video,
        'colors': [const Color(0xFFEC4899), const Color(0xFFBE185D)],
      },
      {
        'name': 'DEEP DIVE',
        'desc': 'CONCEPT UNLOCK',
        'icon': LucideIcons.lightbulb,
        'colors': [const Color(0xFF06B6D4), const Color(0xFF0284C7)],
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _PowerToolCard(
          name: tool['name'] as String,
          description: tool['desc'] as String,
          icon: tool['icon'] as IconData,
          gradientColors: tool['colors'] as List<Color>,
        );
      },
    );
  }

  Widget _buildInstantPhotoSolve(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(32),
      borderColor: const Color(0xFF8B5CF6).withOpacity(0.5),
      gradientColors: [
        const Color(0xFF8B5CF6).withOpacity(0.4),
        const Color(0xFF6D28D9).withOpacity(0.4),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.camera,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 16),
              Text(
                'INSTANT PHOTO SOLVE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'POINT & DOMINATE - Get AI solutions instantly',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: '📷 ACTIVATE CAMERA',
            onPressed: () {
              // TODO: Implement camera functionality
            },
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            width: double.infinity,
            height: 60,
            borderRadius: 16,
            shadowColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _PowerToolCard extends StatefulWidget {
  final String name;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;

  const _PowerToolCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });

  @override
  State<_PowerToolCard> createState() => _PowerToolCardState();
}

class _PowerToolCardState extends State<_PowerToolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
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
                color: widget.gradientColors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 36,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

