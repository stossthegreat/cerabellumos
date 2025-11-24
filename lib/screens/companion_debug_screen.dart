import 'package:flutter/material.dart';
import '../companion/companion_state.dart';
import '../companion/neural_companion_widget.dart';
import '../core/design_tokens.dart';

/// Debug screen for testing all companion states
/// Access via long-press on companion widget
class CompanionDebugScreen extends StatefulWidget {
  const CompanionDebugScreen({super.key});

  @override
  State<CompanionDebugScreen> createState() => _CompanionDebugScreenState();
}

class _CompanionDebugScreenState extends State<CompanionDebugScreen> {
  CompanionState? _selectedState;

  @override
  Widget build(BuildContext context) {
    if (_selectedState != null) {
      return _buildFullScreenView();
    }

    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: DesignTokens.backgroundSecondary,
        title: const Text(
          'Companion Debug',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: CompanionState.values.map((state) {
              return _buildStateCard(state);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStateCard(CompanionState state) {
    final emotion = _getEmotionForState(state);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedState = state;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: DesignTokens.borderDefault,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuralCompanionWidget(
              emotion: emotion,
              size: 80,
            ),
            const SizedBox(height: 12),
            Text(
              _getStateName(state),
              style: DesignTokens.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                emotion.reason,
                style: DesignTokens.bodySmall.copyWith(
                  color: DesignTokens.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenView() {
    final emotion = _getEmotionForState(_selectedState!);
    
    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            // Full screen companion
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeuralCompanionWidget(
                    emotion: emotion,
                    size: 200,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _getStateName(_selectedState!),
                    style: DesignTokens.displayLarge,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      emotion.reason,
                      style: DesignTokens.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Intensity: ${(emotion.intensity * 100).toInt()}%',
                    style: DesignTokens.labelMedium,
                  ),
                ],
              ),
            ),
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _selectedState = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStateName(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return 'Idle';
      case CompanionState.focused:
        return 'Focused';
      case CompanionState.alert:
        return 'Alert';
      case CompanionState.proud:
        return 'Proud';
      case CompanionState.disappointed:
        return 'Disappointed';
      case CompanionState.curious:
        return 'Curious';
      case CompanionState.sleeping:
        return 'Sleeping';
    }
  }

  CompanionEmotionData _getEmotionForState(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const CompanionEmotionData(
          state: CompanionState.idle,
          reason: 'Ready to learn together',
          intensity: 0.5,
        );
      case CompanionState.focused:
        return const CompanionEmotionData(
          state: CompanionState.focused,
          reason: '7 day streak! Keep going',
          intensity: 0.8,
        );
      case CompanionState.alert:
        return const CompanionEmotionData(
          state: CompanionState.alert,
          reason: 'Chemistry exam in 3 days!',
          intensity: 1.0,
        );
      case CompanionState.proud:
        return const CompanionEmotionData(
          state: CompanionState.proud,
          reason: 'You\'re crushing it! 90 mins studied',
          intensity: 0.95,
        );
      case CompanionState.disappointed:
        return const CompanionEmotionData(
          state: CompanionState.disappointed,
          reason: 'Haven\'t started studying yet...',
          intensity: 0.4,
        );
      case CompanionState.curious:
        return const CompanionEmotionData(
          state: CompanionState.curious,
          reason: 'What should we learn today?',
          intensity: 0.7,
        );
      case CompanionState.sleeping:
        return const CompanionEmotionData(
          state: CompanionState.sleeping,
          reason: 'Resting for tomorrow\'s focus',
          intensity: 0.3,
        );
    }
  }
}

