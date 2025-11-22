import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/animated_blob.dart';

class VideoMasteryScreen extends StatefulWidget {
  const VideoMasteryScreen({super.key});

  @override
  State<VideoMasteryScreen> createState() => _VideoMasteryScreenState();
}

class _VideoMasteryScreenState extends State<VideoMasteryScreen> {
  bool _isProcessing = false;
  bool _showQuiz = false;
  int _currentQuizIndex = 0;
  int _correctAnswers = 0;
  String? _selectedAnswer;
  
  final List<Map<String, dynamic>> _concepts = [
    {'time': '0:45', 'title': 'Introduction to Photosynthesis', 'key': true},
    {'time': '2:15', 'title': 'Light-Dependent Reactions', 'key': true},
    {'time': '5:30', 'title': 'Calvin Cycle Explained', 'key': true},
    {'time': '8:00', 'title': 'Key Takeaways', 'key': false},
  ];
  
  final List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What is the primary function of photosynthesis?',
      'options': [
        'Convert light energy into chemical energy',
        'Break down glucose for energy',
        'Produce carbon dioxide',
        'Absorb water from soil',
      ],
      'correct': 0,
    },
    {
      'question': 'Where do light-dependent reactions occur?',
      'options': [
        'Mitochondria',
        'Nucleus',
        'Thylakoid membrane',
        'Cytoplasm',
      ],
      'correct': 2,
    },
    {
      'question': 'What is the product of the Calvin Cycle?',
      'options': [
        'Oxygen',
        'Water',
        'Glucose (G3P)',
        'Carbon dioxide',
      ],
      'correct': 2,
    },
  ];

  void _startProcessing() {
    setState(() {
      _isProcessing = true;
    });
    
    // Simulate AI processing
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _startQuiz() {
    setState(() {
      _showQuiz = true;
      _currentQuizIndex = 0;
      _correctAnswers = 0;
      _selectedAnswer = null;
    });
  }

  void _submitAnswer(int selectedIndex) {
    final correct = _quizQuestions[_currentQuizIndex]['correct'];
    
    setState(() {
      _selectedAnswer = selectedIndex.toString();
      if (selectedIndex == correct) {
        _correctAnswers++;
      }
    });
    
    // Auto-advance after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (_currentQuizIndex < _quizQuestions.length - 1) {
          setState(() {
            _currentQuizIndex++;
            _selectedAnswer = null;
          });
        }
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
            right: -150,
            child: AnimatedBlob(
              color: Color(0xFFEC4899),
              size: 400,
            ),
          ),
          const Positioned(
            bottom: -100,
            left: -100,
            child: AnimatedBlob(
              color: Color(0xFFBE185D),
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
                  child: _showQuiz
                      ? _buildQuizView(context)
                      : (_isProcessing
                          ? _buildProcessingView(context)
                          : _buildVideoView(context)),
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
            '🎥 VIDEO MASTERY',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          if (!_showQuiz)
            IconButton(
              onPressed: () {},
              icon: const Icon(
                LucideIcons.settings,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Upload Area
          GlassmorphicCard(
            padding: const EdgeInsets.all(32),
            borderColor: const Color(0xFFEC4899).withOpacity(0.5),
            gradientColors: [
              const Color(0xFFEC4899).withOpacity(0.3),
              const Color(0xFFEC4899).withOpacity(0.1),
            ],
            child: Column(
              children: [
                const Icon(
                  LucideIcons.video,
                  color: Color(0xFFEC4899),
                  size: 64,
                ),
                const SizedBox(height: 20),
                const Text(
                  'UPLOAD VIDEO OR PASTE URL',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'YouTube, Vimeo, or local files supported',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.upload, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'UPLOAD FILE',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _startProcessing,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFEC4899).withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.link, color: Color(0xFFEC4899), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'PASTE URL',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFEC4899),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Recent Videos Section
          const Text(
            'RECENT VIDEOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFFEC4899),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          
          GlassmorphicCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.play,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photosynthesis Explained',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10:34 • Biology',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: Color(0xFFEC4899),
                  size: 24,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Concept Timeline (Demo)
          const Text(
            'KEY CONCEPTS TIMELINE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFFEC4899),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._concepts.map((concept) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      concept['time'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEC4899),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      concept['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (concept['key'])
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFACC15).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'KEY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFACC15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )),
          
          const SizedBox(height: 24),
          
          // Generate Quiz Button
          GestureDetector(
            onTap: _startQuiz,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEC4899).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.brain, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'GENERATE AI QUIZ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProcessingView(BuildContext context) {
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
                  colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEC4899).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.brain,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'AI EXTRACTING KNOWLEDGE...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing video content and generating smart timestamps',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEC4899)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizView(BuildContext context) {
    final isCompleted = _currentQuizIndex >= _quizQuestions.length;
    
    if (isCompleted) {
      return _buildQuizResults(context);
    }
    
    final question = _quizQuestions[_currentQuizIndex];
    final options = question['options'] as List<String>;
    final correctIndex = question['correct'] as int;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentQuizIndex + 1) / _quizQuestions.length,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEC4899)),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_currentQuizIndex + 1}/${_quizQuestions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Question
          GlassmorphicCard(
            padding: const EdgeInsets.all(24),
            borderColor: const Color(0xFFEC4899).withOpacity(0.5),
            child: Text(
              question['question'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Options
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == index.toString();
            final isCorrect = index == correctIndex;
            final showFeedback = _selectedAnswer != null;
            
            Color? borderColor;
            Color? backgroundColor;
            
            if (showFeedback) {
              if (isSelected) {
                borderColor = isCorrect ? const Color(0xFF10B981) : const Color(0xFFDC2626);
                backgroundColor = isCorrect 
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : const Color(0xFFDC2626).withOpacity(0.2);
              } else if (isCorrect) {
                borderColor = const Color(0xFF10B981);
                backgroundColor = const Color(0xFF10B981).withOpacity(0.2);
              }
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: _selectedAnswer == null ? () => _submitAnswer(index) : null,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor ?? Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: borderColor ?? const Color(0xFFEC4899).withOpacity(0.3),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
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
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showFeedback && (isSelected || isCorrect))
                        Icon(
                          isCorrect ? LucideIcons.checkCircle : LucideIcons.xCircle,
                          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFDC2626),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuizResults(BuildContext context) {
    final percentage = ((_correctAnswers / _quizQuestions.length) * 100).round();
    final passed = percentage >= 70;
    
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
                gradient: LinearGradient(
                  colors: passed 
                      ? [const Color(0xFF10B981), const Color(0xFF059669)]
                      : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (passed ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  passed ? '🎉' : '💪',
                  style: const TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              passed ? 'MASTERED!' : 'KEEP GRINDING!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$percentage% SCORE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: passed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
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
                        '$_correctAnswers',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'CORRECT',
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
                        '${_quizQuestions.length - _correctAnswers}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'WRONG',
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
                  _showQuiz = false;
                  _currentQuizIndex = 0;
                  _correctAnswers = 0;
                  _selectedAnswer = null;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC4899).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'WATCH AGAIN',
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

