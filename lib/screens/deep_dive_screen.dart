import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/animated_blob.dart';

class DeepDiveScreen extends StatefulWidget {
  const DeepDiveScreen({super.key});

  @override
  State<DeepDiveScreen> createState() => _DeepDiveScreenState();
}

class _DeepDiveScreenState extends State<DeepDiveScreen> {
  String _selectedConcept = 'root';
  bool _showLesson = false;
  int _currentLessonIndex = 0;
  Set<String> _unlockedConcepts = {'root', 'basics', 'intermediate'};
  Set<String> _completedConcepts = {};
  
  final Map<String, Map<String, dynamic>> _conceptTree = {
    'root': {
      'title': 'Quantum Physics',
      'children': ['basics', 'intermediate', 'advanced'],
      'icon': LucideIcons.atom,
      'color': Color(0xFF06B6D4),
    },
    'basics': {
      'title': 'Wave-Particle Duality',
      'children': ['wave', 'particle'],
      'icon': LucideIcons.waves,
      'color': Color(0xFF10B981),
    },
    'wave': {
      'title': 'Wave Properties',
      'children': [],
      'icon': LucideIcons.activity,
      'color': Color(0xFF8B5CF6),
    },
    'particle': {
      'title': 'Particle Properties',
      'children': [],
      'icon': LucideIcons.circle,
      'color': Color(0xFFEC4899),
    },
    'intermediate': {
      'title': 'Uncertainty Principle',
      'children': ['heisenberg', 'applications'],
      'icon': LucideIcons.target,
      'color': Color(0xFFF59E0B),
    },
    'heisenberg': {
      'title': 'Heisenberg Equation',
      'children': [],
      'icon': LucideIcons.calculator,
      'color': Color(0xFF06B6D4),
    },
    'applications': {
      'title': 'Real-World Uses',
      'children': [],
      'icon': LucideIcons.sparkles,
      'color': Color(0xFFDC2626),
    },
    'advanced': {
      'title': 'Quantum Entanglement',
      'children': [],
      'icon': LucideIcons.link,
      'color': Color(0xFF8B5CF6),
    },
  };

  final List<Map<String, dynamic>> _lessonPages = [
    {
      'type': 'intro',
      'title': 'Wave-Particle Duality',
      'content': 'Light and matter exhibit both wave and particle properties.',
      'image': '🌊',
    },
    {
      'type': 'explanation',
      'title': 'The Double-Slit Experiment',
      'content': 'When particles pass through two slits, they create an interference pattern - a wave behavior!',
      'image': '⚡',
    },
    {
      'type': 'quiz',
      'question': 'What does wave-particle duality mean?',
      'options': [
        'Particles can only be waves',
        'Light behaves as both wave and particle',
        'Waves cannot be particles',
        'Only electrons have this property',
      ],
      'correct': 1,
    },
    {
      'type': 'summary',
      'title': 'Key Takeaway',
      'content': 'Matter and light can exhibit properties of both waves and particles depending on how we observe them.',
      'image': '✨',
    },
  ];

  void _selectConcept(String conceptId) {
    if (_unlockedConcepts.contains(conceptId)) {
      setState(() {
        _selectedConcept = conceptId;
      });
    }
  }

  void _startLesson() {
    setState(() {
      _showLesson = true;
      _currentLessonIndex = 0;
    });
  }

  void _nextLesson() {
    if (_currentLessonIndex < _lessonPages.length - 1) {
      setState(() {
        _currentLessonIndex++;
      });
    } else {
      // Complete the lesson
      setState(() {
        _completedConcepts.add(_selectedConcept);
        _showLesson = false;
        
        // Unlock children
        final children = _conceptTree[_selectedConcept]?['children'] as List?;
        if (children != null) {
          _unlockedConcepts.addAll(children.cast<String>());
        }
      });
    }
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
            left: -100,
            child: AnimatedBlob(
              color: Color(0xFF06B6D4),
              size: 400,
            ),
          ),
          const Positioned(
            bottom: -150,
            right: -100,
            child: AnimatedBlob(
              color: Color(0xFF0284C7),
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
                  child: _showLesson
                      ? _buildLessonView(context)
                      : _buildConceptTreeView(context),
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
            onPressed: () {
              if (_showLesson) {
                setState(() {
                  _showLesson = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              LucideIcons.arrowLeft,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '💡 DEEP DIVE',
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
                colors: [Color(0xFF06B6D4), Color(0xFF0284C7)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.award, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${_completedConcepts.length} MASTERED',
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

  Widget _buildConceptTreeView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Input
          GlassmorphicCard(
            padding: const EdgeInsets.all(20),
            borderColor: const Color(0xFF06B6D4).withOpacity(0.5),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.search,
                  color: Color(0xFF06B6D4),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search topics or explore the tree below...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Knowledge Tree Title
          const Text(
            'KNOWLEDGE TREE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF06B6D4),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          
          // Root Concept
          _buildConceptNode('root', 0),
          
          // Level 1 Children
          ..._buildChildNodes('root', 1),
          
          const SizedBox(height: 32),
          
          // Selected Concept Detail
          if (_selectedConcept != 'root')
            _buildConceptDetail(context),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  List<Widget> _buildChildNodes(String parentId, int level) {
    final parent = _conceptTree[parentId];
    if (parent == null) return [];
    
    final children = parent['children'] as List;
    final widgets = <Widget>[];
    
    for (final childId in children) {
      widgets.add(Padding(
        padding: EdgeInsets.only(left: level * 30.0, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Line
            Container(
              width: 20,
              height: 2,
              color: const Color(0xFF06B6D4).withOpacity(0.3),
            ),
            const SizedBox(height: 8),
            // Node
            _buildConceptNode(childId, level),
            // Recursively build children
            ..._buildChildNodes(childId, level + 1),
          ],
        ),
      ));
    }
    
    return widgets;
  }

  Widget _buildConceptNode(String conceptId, int level) {
    final concept = _conceptTree[conceptId]!;
    final isUnlocked = _unlockedConcepts.contains(conceptId);
    final isCompleted = _completedConcepts.contains(conceptId);
    final isSelected = _selectedConcept == conceptId;
    
    return GestureDetector(
      onTap: () => _selectConcept(conceptId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    (concept['color'] as Color).withOpacity(0.3),
                    (concept['color'] as Color).withOpacity(0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(isUnlocked ? 0.05 : 0.02),
          border: Border.all(
            color: isSelected
                ? (concept['color'] as Color).withOpacity(0.8)
                : Colors.white.withOpacity(isUnlocked ? 0.2 : 0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isUnlocked
                    ? LinearGradient(
                        colors: [
                          concept['color'] as Color,
                          (concept['color'] as Color).withOpacity(0.7),
                        ],
                      )
                    : null,
                color: isUnlocked ? null : Colors.grey.shade800,
              ),
              child: Icon(
                isCompleted ? LucideIcons.checkCircle : (concept['icon'] as IconData),
                color: isUnlocked ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concept['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isUnlocked ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCompleted
                        ? 'COMPLETED'
                        : (isUnlocked ? 'TAP TO LEARN' : 'LOCKED'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : (isUnlocked ? const Color(0xFF06B6D4) : Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              const Icon(
                LucideIcons.award,
                color: Color(0xFFFACC15),
                size: 24,
              ),
            if (!isUnlocked)
              const Icon(
                LucideIcons.lock,
                color: Colors.grey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptDetail(BuildContext context) {
    final concept = _conceptTree[_selectedConcept]!;
    final isCompleted = _completedConcepts.contains(_selectedConcept);
    
    return GlassmorphicCard(
      padding: const EdgeInsets.all(24),
      borderColor: (concept['color'] as Color).withOpacity(0.5),
      gradientColors: [
        (concept['color'] as Color).withOpacity(0.3),
        (concept['color'] as Color).withOpacity(0.1),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                concept['icon'] as IconData,
                color: concept['color'] as Color,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  concept['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(
                  LucideIcons.checkCircle,
                  color: Color(0xFF10B981),
                  size: 28,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Master this concept to unlock deeper topics and build your knowledge tree.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade300,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(LucideIcons.clock, color: Color(0xFF06B6D4), size: 16),
              const SizedBox(width: 8),
              Text(
                '~5 minutes',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 20),
              const Icon(LucideIcons.bookOpen, color: Color(0xFF06B6D4), size: 16),
              const SizedBox(width: 8),
              Text(
                '4 lessons',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: isCompleted ? null : _startLesson,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: isCompleted
                    ? null
                    : LinearGradient(
                        colors: [
                          concept['color'] as Color,
                          (concept['color'] as Color).withOpacity(0.7),
                        ],
                      ),
                color: isCompleted ? Colors.grey.shade800 : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isCompleted
                    ? []
                    : [
                        BoxShadow(
                          color: (concept['color'] as Color).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isCompleted ? LucideIcons.checkCircle : LucideIcons.playCircle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isCompleted ? 'ALREADY MASTERED' : 'START LEARNING',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
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

  Widget _buildLessonView(BuildContext context) {
    final lesson = _lessonPages[_currentLessonIndex];
    final concept = _conceptTree[_selectedConcept]!;
    
    return Column(
      children: [
        // Progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentLessonIndex + 1) / _lessonPages.length,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(concept['color'] as Color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentLessonIndex + 1}/${_lessonPages.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Lesson Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: lesson['type'] == 'quiz'
                ? _buildQuizLesson(lesson, concept)
                : _buildContentLesson(lesson, concept),
          ),
        ),
        
        // Next Button
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: GestureDetector(
            onTap: _nextLesson,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    concept['color'] as Color,
                    (concept['color'] as Color).withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (concept['color'] as Color).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                _currentLessonIndex == _lessonPages.length - 1 ? 'COMPLETE' : 'NEXT',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentLesson(Map<String, dynamic> lesson, Map<String, dynamic> concept) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                concept['color'] as Color,
                (concept['color'] as Color).withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (concept['color'] as Color).withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              lesson['image'] ?? '📚',
              style: const TextStyle(fontSize: 60),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          lesson['title'] ?? '',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        GlassmorphicCard(
          padding: const EdgeInsets.all(24),
          child: Text(
            lesson['content'] ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade200,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizLesson(Map<String, dynamic> lesson, Map<String, dynamic> concept) {
    final options = lesson['options'] as List<String>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassmorphicCard(
          padding: const EdgeInsets.all(24),
          borderColor: (concept['color'] as Color).withOpacity(0.5),
          child: Text(
            lesson['question'] ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
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
                        color: (concept['color'] as Color).withOpacity(0.3),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index),
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
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

