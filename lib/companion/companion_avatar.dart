import 'package:flutter/material.dart';
import 'companion_state.dart';

/// CompanionAvatar Widget - Displays companion image based on state
/// Smooth crossfade between states
class CompanionAvatar extends StatelessWidget {
  final CompanionState state;
  final double size;

  const CompanionAvatar({
    required this.state,
    this.size = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final path = companionFrames[state]!;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Image.asset(
        path,
        key: ValueKey(path),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading companion frame: $path');
          return Icon(
            Icons.error_outline,
            size: size,
            color: Colors.red,
          );
        },
      ),
    );
  }
}

