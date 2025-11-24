import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../companion/expression_state.dart';
import '../companion/behavior_state.dart';
import '../companion/companion_controller.dart';
import '../companion/companion_view.dart';
import '../core/design_tokens.dart';

/// Debug screen for testing all companion expressions and behaviors
/// Access via long-press on companion widget
class CompanionDebugScreen extends StatefulWidget {
  const CompanionDebugScreen({super.key});

  @override
  State<CompanionDebugScreen> createState() => _CompanionDebugScreenState();
}

class _CompanionDebugScreenState extends State<CompanionDebugScreen> {
  ExpressionState? _selectedExpression;

  @override
  Widget build(BuildContext context) {
    if (_selectedExpression != null) {
      return _buildFullScreenView();
    }

    return Scaffold(
      backgroundColor: DesignTokens.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: DesignTokens.backgroundSecondary,
        title: const Text(
          'Companion Debug - Expression States',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
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
                      'PNG Asset Requirements',
                      style: DesignTokens.heading3.copyWith(
                        color: DesignTokens.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Place 6 PNG files in: assets/companion/\n'
                      '• neutral.png\n'
                      '• smile.png\n'
                      '• closed_eyes.png\n'
                      '• talking_open.png\n'
                      '• worried.png\n'
                      '• alert.png',
                      style: DesignTokens.bodySmall,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text('Expression States (6)', style: DesignTokens.heading2),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: ExpressionState.values.map((state) {
                  return _buildExpressionCard(state);
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              Text('Behavior Triggers', style: DesignTokens.heading2),
              const SizedBox(height: 16),
              
              ...BehaviorState.values.map((behavior) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildBehaviorButton(behavior),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpressionCard(ExpressionState state) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedExpression = state;
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
            // Show the companion temporarily with this expression
            SizedBox(
              width: 80,
              height: 80,
              child: Consumer<CompanionController>(
                builder: (context, controller, child) {
                  // Temporarily override to show this expression
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      controller.setExpressionOverride(
                        state,
                        duration: const Duration(milliseconds: 100),
                      );
                    }
                  });
                  return const CompanionView(size: 80);
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              ExpressionAssets.getLabel(state),
              style: DesignTokens.heading3.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBehaviorButton(BehaviorState behavior) {
    return Consumer<CompanionController>(
      builder: (context, controller, child) {
        return ElevatedButton(
          onPressed: () {
            controller.setBehaviorState(behavior);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Triggered: ${BehaviorToExpression.getLabel(behavior)}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignTokens.backgroundSecondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: DesignTokens.borderDefault),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.play_arrow, size: 20),
              const SizedBox(width: 12),
              Text(
                BehaviorToExpression.getLabel(behavior),
                style: DesignTokens.bodyMedium,
              ),
            ],
          ),
        );
      },
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
                  Consumer<CompanionController>(
                    builder: (context, controller, child) {
                      controller.setExpressionOverride(_selectedExpression!);
                      return const CompanionView(size: 200);
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    ExpressionAssets.getLabel(_selectedExpression!),
                    style: DesignTokens.displayLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Asset: ${ExpressionAssets.getAssetPath(_selectedExpression!)}',
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
                    _selectedExpression = null;
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
