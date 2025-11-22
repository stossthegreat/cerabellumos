import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/animated_blob.dart';

class AIScannerScreen extends StatefulWidget {
  const AIScannerScreen({super.key});

  @override
  State<AIScannerScreen> createState() => _AIScannerScreenState();
}

class _AIScannerScreenState extends State<AIScannerScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _showSolution = false;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });
    _scanController.repeat();
    
    // Simulate AI processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _showSolution = true;
        });
        _scanController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background
          const Positioned(
            top: -100,
            right: -100,
            child: AnimatedBlob(
              color: Color(0xFF8B5CF6),
              size: 400,
            ),
          ),
          const Positioned(
            bottom: -150,
            left: -100,
            child: AnimatedBlob(
              color: Color(0xFF6D28D9),
              size: 450,
              duration: Duration(seconds: 9),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _showSolution 
                    ? _buildSolutionView(context)
                    : _buildCameraView(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              LucideIcons.arrowLeft,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '📸 AI SCANNER',
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
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.zap, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  '95% POWER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(0),
              borderColor: const Color(0xFF8B5CF6).withOpacity(0.5),
              gradientColors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.3),
              ],
              child: Stack(
                children: [
                  // Camera Viewfinder Placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.camera,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _isScanning ? 'SCANNING...' : 'POINT CAMERA AT PROBLEM',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.6),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // AR Grid Overlay
                  if (!_isScanning)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ARGridPainter(),
                      ),
                    ),
                  
                  // Scanning Animation
                  if (_isScanning)
                    AnimatedBuilder(
                      animation: _scanController,
                      builder: (context, child) {
                        return Positioned(
                          top: _scanController.value * MediaQuery.of(context).size.height * 0.6,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF8B5CF6).withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  
                  // Corner Brackets
                  ..._buildCornerBrackets(),
                ],
              ),
            ),
          ),
        ),
        
        // Bottom Action Area
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              // Scan Button
              GestureDetector(
                onTap: _isScanning ? null : _startScan,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isScanning
                          ? [Colors.grey.shade700, Colors.grey.shade800]
                          : [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isScanning ? LucideIcons.loader : LucideIcons.scan,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isScanning ? 'ANALYZING PROBLEM...' : 'TAP TO SCAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade400,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSolutionView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Banner
          GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            borderColor: const Color(0xFF10B981).withOpacity(0.5),
            gradientColors: [
              const Color(0xFF10B981).withOpacity(0.3),
              const Color(0xFF10B981).withOpacity(0.1),
            ],
            child: const Row(
              children: [
                Icon(LucideIcons.checkCircle, color: Color(0xFF10B981), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'SOLUTION FOUND',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '98% CONFIDENCE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Problem Statement
          const Text(
            'PROBLEM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF8B5CF6),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Solve for x: 2x + 5 = 13',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Solution Steps
          const Text(
            'SOLUTION STEPS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF8B5CF6),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._buildSolutionSteps(),
          
          const SizedBox(height: 24),
          
          // Final Answer
          GlassmorphicCard(
            padding: const EdgeInsets.all(24),
            borderColor: const Color(0xFF10B981).withOpacity(0.5),
            gradientColors: [
              const Color(0xFF10B981).withOpacity(0.3),
              const Color(0xFF10B981).withOpacity(0.1),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FINAL ANSWER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10B981),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'x = 4',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'EXPLAIN DEEPER',
                  LucideIcons.brain,
                  const Color(0xFF8B5CF6),
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'SIMILAR PROBLEMS',
                  LucideIcons.layers,
                  const Color(0xFFF59E0B),
                  () {},
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          _buildActionButton(
            'ADD TO FLASHCARDS',
            LucideIcons.bookmark,
            const Color(0xFFEC4899),
            () {},
            fullWidth: true,
          ),
          
          const SizedBox(height: 20),
          
          // Scan Again Button
          GestureDetector(
            onTap: () {
              setState(() {
                _showSolution = false;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'SCAN NEW PROBLEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8B5CF6),
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  List<Widget> _buildSolutionSteps() {
    final steps = [
      {'step': '1', 'text': 'Subtract 5 from both sides', 'equation': '2x + 5 - 5 = 13 - 5'},
      {'step': '2', 'text': 'Simplify', 'equation': '2x = 8'},
      {'step': '3', 'text': 'Divide both sides by 2', 'equation': '2x ÷ 2 = 8 ÷ 2'},
      {'step': '4', 'text': 'Simplify to get answer', 'equation': 'x = 4'},
    ];
    
    return steps.map((step) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassmorphicCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                  ),
                ),
                child: Center(
                  child: Text(
                    step['step']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
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
                      step['text']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step['equation']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap, {bool fullWidth = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    return [
      // Top-left
      Positioned(
        top: 30,
        left: 30,
        child: _buildCornerBracket(true, true),
      ),
      // Top-right
      Positioned(
        top: 30,
        right: 30,
        child: _buildCornerBracket(true, false),
      ),
      // Bottom-left
      Positioned(
        bottom: 30,
        left: 30,
        child: _buildCornerBracket(false, true),
      ),
      // Bottom-right
      Positioned(
        bottom: 30,
        right: 30,
        child: _buildCornerBracket(false, false),
      ),
    ];
  }

  Widget _buildCornerBracket(bool isTop, bool isLeft) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _CornerBracketPainter(isTop: isTop, isLeft: isLeft),
      ),
    );
  }
}

class _ARGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B5CF6).withOpacity(0.2)
      ..strokeWidth = 1;

    const gridSize = 40.0;

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

class _CornerBracketPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;

  _CornerBracketPainter({required this.isTop, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    if (isTop && isLeft) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

