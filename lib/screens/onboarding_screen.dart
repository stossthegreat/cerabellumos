import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _blobController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _blobController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  Future<void> _finishOnboarding() async {
    await context.read<AppState>().completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ANIMATED BACKGROUND WITH BLOBS
          AnimatedBuilder(
            animation: _blobController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100 + (_blobController.value * 50),
                    left: -150 + (_blobController.value * 40),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF8B5CF6).withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200 + (_blobController.value * 60),
                    right: -100 - (_blobController.value * 30),
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFDC2626).withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50 - (_blobController.value * 40),
                    left: MediaQuery.of(context).size.width / 2 - 200,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFEC4899).withOpacity(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // FLOATING PARTICLES
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Stack(
                children: List.generate(20, (index) {
                  final offset = index * 0.05;
                  final progress = (_particleController.value + offset) % 1.0;
                  final x = MediaQuery.of(context).size.width *
                      (0.1 + (index % 5) * 0.2);
                  final y = MediaQuery.of(context).size.height * progress;
                  
                  return Positioned(
                    left: x + math.sin(progress * math.pi * 2) * 20,
                    top: y,
                    child: Opacity(
                      opacity: (1 - progress) * 0.3,
                      child: Container(
                        width: 4 + (index % 3) * 2,
                        height: 4 + (index % 3) * 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              [
                                const Color(0xFF8B5CF6),
                                const Color(0xFFEC4899),
                                const Color(0xFF22D3EE),
                              ][index % 3],
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // PAGE VIEW
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildPage1(),
              _buildPage2(),
              _buildPage3(),
            ],
          ),

          // PAGE INDICATOR
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _currentPage == index
                        ? const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                          )
                        : null,
                    color:
                        _currentPage == index ? null : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // SKIP BUTTON
          if (_currentPage < 2)
            Positioned(
              top: 60,
              right: 24,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return FadeTransition(
      opacity: _fadeController,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing gradient circle with brain emoji
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.1);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8B5CF6), Color(0xFFA855F7), Color(0xFFEC4899)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.6 + _pulseController.value * 0.2),
                            blurRadius: 60 + (_pulseController.value * 20),
                            spreadRadius: 20 + (_pulseController.value * 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '🧠',
                          style: TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
              const Text(
                'WELCOME TO',
                style: TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                ).createShader(bounds),
                child: const Text(
                  'CEREBELLUM OS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 800.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              const SizedBox(height: 24),
              Text(
                'The Ultimate Study Platform\nDesigned for Elite Performance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 60),
              _buildContinueButton()
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.rotate(
                angle: math.sin(_pulseController.value * math.pi * 2) * 0.1,
                child: Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.15),
                  child: const Text(
                    '⚡',
                    style: TextStyle(fontSize: 100),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'BEAST MODE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: const Color(0xFF8B5CF6)),
          const SizedBox(height: 16),
          const Text(
            'LEARNING',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, delay: 500.ms, color: const Color(0xFFEC4899)),
          const SizedBox(height: 40),
          _buildFeatureItem('🎯', 'AI-Powered Study Assistant', 'Get instant help with any topic')
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.2, end: 0),
          const SizedBox(height: 20),
          _buildFeatureItem('📊', 'Track Your Progress', 'See your mastery grow daily')
              .animate()
              .fadeIn(delay: 400.ms)
              .slideX(begin: -0.2, end: 0),
          const SizedBox(height: 20),
          _buildFeatureItem('🔥', 'Build Unstoppable Streaks', 'Consistency is your superpower')
              .animate()
              .fadeIn(delay: 600.ms)
              .slideX(begin: -0.2, end: 0),
          const SizedBox(height: 60),
          _buildContinueButton()
              .animate()
              .fadeIn(delay: 800.ms)
              .scale(),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin(_pulseController.value * math.pi * 2) * 10),
                child: Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.1),
                  child: const Text(
                    '🚀',
                    style: TextStyle(fontSize: 100),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            ).createShader(bounds),
            child: const Text(
              'READY TO\nDOMINATE?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 3000.ms),
          const SizedBox(height: 24),
          Text(
            'Transform your study sessions\ninto elite performance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 80),
          GestureDetector(
            onTap: _finishOnboarding,
            child: Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🔥 LET\'S GO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: Colors.white)
              .shake(hz: 0.5, curve: Curves.easeInOut),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () {
        if (_currentPage < 2) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Container(
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'CONTINUE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

