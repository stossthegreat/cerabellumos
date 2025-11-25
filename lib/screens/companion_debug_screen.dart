import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../companion/companion_state.dart';
import '../companion/companion_avatar.dart';
import '../companion/companion_controller.dart';
import '../core/design_tokens.dart';

/// Debug screen for testing all 18 companion states
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
          'Companion Debug - 18 States',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Test talking animation
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.white),
            onPressed: () {
              final controller = context.read<CompanionController>();
              if (controller.isTalking) {
                controller.stopTalking();
              } else {
                controller.startTalking();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DesignTokens.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DesignTokens.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '18 Companion States Loaded ✅',
                      style: DesignTokens.heading3.copyWith(
                        color: DesignTokens.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All images from assets/companion/\n'
                      'Tap any state to preview full screen\n'
                      'Volume icon = test talking animation',
                      style: DesignTokens.bodySmall,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // State categories
              _buildStateCategory('Default', [CompanionState.neutral_default]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Mouth A (4)', [
                CompanionState.mouth_A_1,
                CompanionState.mouth_A_2,
                CompanionState.mouth_A_3,
                CompanionState.mouth_A_4,
              ]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Mouth O (2)', [
                CompanionState.mouth_O_1,
                CompanionState.mouth_O_2,
              ]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Mouth E (3)', [
                CompanionState.mouth_E_1,
                CompanionState.mouth_E_2,
                CompanionState.mouth_E_3,
              ]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Smiles (3)', [
                CompanionState.smile_soft,
                CompanionState.smile_big,
                CompanionState.smile_confident,
              ]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Eyes Closed (3)', [
                CompanionState.eyes_closed_1,
                CompanionState.eyes_closed_2,
                CompanionState.eyes_closed_soft,
              ]),
              const SizedBox(height: 16),
              
              _buildStateCategory('Serious (2)', [
                CompanionState.serious_1,
                CompanionState.serious_2,
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateCategory(String title, List<CompanionState> states) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: DesignTokens.heading2),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: states.length > 2 ? 3 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: states.map((state) => _buildStateCard(state)).toList(),
        ),
      ],
    );
  }

  Widget _buildStateCard(CompanionState state) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedState = state;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: DesignTokens.borderDefault,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CompanionAvatar(
                state: state,
                size: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                state.toString().split('.').last,
                style: DesignTokens.labelSmall,
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
    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CompanionAvatar(
                    state: _selectedState!,
                    size: 300,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _selectedState.toString().split('.').last,
                    style: DesignTokens.displayLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Asset: ${companionFrames[_selectedState!]}',
                    style: DesignTokens.bodyMedium.copyWith(
                      color: DesignTokens.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
}
