import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/animated_blob.dart';

class FlashcardTurboScreen extends StatefulWidget {
  const FlashcardTurboScreen({super.key});

  @override
  State<FlashcardTurboScreen> createState() => _FlashcardTurboScreenState();
}

class _FlashcardTurboScreenState extends State<FlashcardTurboScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _masteredCount = 0;
  int _needReviewCount = 0;
  int _streak = 7;
  late AnimationController _flipController;
  late AnimationController _swipeController;
  late Animation<double> _flipAnimation;
  Offset _dragOffset = Offset.zero;
  
  final List<Map<String, String>> _flashcards = [
    {
      'question': 'What is the powerhouse of the cell?',
      'answer': 'Mitochondria',
      'subject': 'Biology',
    },
    {
      'question': 'Solve: d/dx (x²)',
      'answer': '2x',
      'subject': 'Calculus',
    },
    {
      'question': 'Capital of France?',
      'answer': 'Paris',
      'subject': 'Geography',
    },
    {
      'question': 'What is Newton\'s 2nd Law?',
      'answer': 'F = ma (Force equals mass times acceleration)',
      'subject': 'Physics',
    },
    {
      'question': 'Who wrote "1984"?',
      'answer': 'George Orwell',
      'subject': 'Literature',
    },
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
      setState(() => _isFlipped = false);
    } else {
      _flipController.forward();
      setState(() => _isFlipped = true);
    }
  }

  void _swipeCard(bool mastered) {
    setState(() {
      if (mastered) {
        _masteredCount++;
      } else {
        _needReviewCount++;
      }
      
      if (_currentIndex < _flashcards.length - 1) {
        _currentIndex++;
        _isFlipped = false;
        _flipController.reset();
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
            top: -150,
            left: -100,
            child: AnimatedBlob(
              color: Color(0xFFF59E0B),
              size: 400,
            ),
          ),
          const Positioned(
            bottom: -100,
            right: -150,
            child: AnimatedBlob(
              color: Color(0xFFD97706),
              size: 450,
              duration: Duration(seconds: 9),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildStats(context),
                Expanded(
                  child: _currentIndex >= _flashcards.length
                      ? _buildCompletionView(context)
                      : _buildCardStack(context),
                ),
                if (_currentIndex < _flashcards.length)
                  _buildBottomActions(context),
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
            '🃏 FLASHCARD TURBO',
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
                colors: [Color(0xFFDC2626), Color(0xFFF97316)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.flame, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '$_streak DAY STREAK',
                  style: const TextStyle(
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

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              gradientColors: [
                const Color(0xFF10B981).withOpacity(0.3),
                const Color(0xFF10B981).withOpacity(0.1),
              ],
              child: Column(
                children: [
                  const Icon(LucideIcons.checkCircle, color: Color(0xFF10B981), size: 20),
                  const SizedBox(height: 8),
                  Text(
                    '$_masteredCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'MASTERED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              gradientColors: [
                const Color(0xFFF59E0B).withOpacity(0.3),
                const Color(0xFFF59E0B).withOpacity(0.1),
              ],
              child: Column(
                children: [
                  Text(
                    '${_currentIndex + 1}/${_flashcards.length}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'PROGRESS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              gradientColors: [
                const Color(0xFFDC2626).withOpacity(0.3),
                const Color(0xFFDC2626).withOpacity(0.1),
              ],
              child: Column(
                children: [
                  const Icon(LucideIcons.xCircle, color: Color(0xFFDC2626), size: 20),
                  const SizedBox(height: 8),
                  Text(
                    '$_needReviewCount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'REVIEW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GestureDetector(
          onTap: _flipCard,
          onPanUpdate: (details) {
            setState(() {
              _dragOffset += details.delta;
            });
          },
          onPanEnd: (details) {
            if (_dragOffset.dx > 100) {
              _swipeCard(true); // Swipe right - mastered
            } else if (_dragOffset.dx < -100) {
              _swipeCard(false); // Swipe left - need review
            }
            setState(() {
              _dragOffset = Offset.zero;
            });
          },
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final angle = _flipAnimation.value * pi;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle);
              
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: angle < pi / 2
                    ? _buildCardFront()
                    : Transform(
                        transform: Matrix4.identity()..rotateY(pi),
                        alignment: Alignment.center,
                        child: _buildCardBack(),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    final card = _flashcards[_currentIndex];
    
    return Transform.translate(
      offset: _dragOffset,
      child: Transform.rotate(
        angle: _dragOffset.dx / 1000,
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    card['subject']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  card['question']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.eye,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TAP TO REVEAL ANSWER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1,
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

  Widget _buildCardBack() {
    final card = _flashcards[_currentIndex];
    
    return Transform.translate(
      offset: _dragOffset,
      child: Transform.rotate(
        angle: _dragOffset.dx / 1000,
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.checkCircle,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 24),
                Text(
                  card['answer']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SWIPE TO RATE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.arrowRight,
                      color: Colors.white.withOpacity(0.6),
                      size: 20,
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

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Need Review Button
          GestureDetector(
            onTap: () => _swipeCard(false),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.x,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          
          // Flip Button
          GestureDetector(
            onTap: _flipCard,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                LucideIcons.refreshCw,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          
          // Mastered Button
          GestureDetector(
            onTap: () => _swipeCard(true),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionView(BuildContext context) {
    final masteryPercentage = ((_masteredCount / _flashcards.length) * 100).round();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🏆',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'SESSION COMPLETE!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$masteryPercentage% MASTERY RATE',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 40),
            GlassmorphicCard(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(LucideIcons.checkCircle, color: Color(0xFF10B981), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        '$_masteredCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'MASTERED',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(LucideIcons.xCircle, color: Color(0xFFDC2626), size: 32),
                      const SizedBox(height: 8),
                      Text(
                        '$_needReviewCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'NEED REVIEW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  _masteredCount = 0;
                  _needReviewCount = 0;
                  _isFlipped = false;
                  _flipController.reset();
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'START NEW SESSION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'BACK TO POWER TOOLS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

