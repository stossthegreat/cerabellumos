import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'companion_state.dart';

/// Premium neural network visualization - represents intelligence and cognitive state
/// NO mascots, NO faces, NO childish elements
class NeuralCompanionWidget extends StatefulWidget {
  final CompanionEmotionData emotion;
  final double size;

  const NeuralCompanionWidget({
    super.key,
    required this.emotion,
    this.size = 120,
  });

  @override
  State<NeuralCompanionWidget> createState() => _NeuralCompanionWidgetState();
}

class _NeuralCompanionWidgetState extends State<NeuralCompanionWidget>
    with TickerProviderStateMixin {
  late List<NeuralNode> _nodes;
  late List<NeuralConnection> _connections;
  late AnimationController _masterController;
  late List<AnimationController> _pulseControllers;
  final List<SynapsePulse> _activePulses = [];
  final math.Random _random = math.Random();

  // State-specific parameters
  int _activePulseCount = 2;
  double _pulseSpeed = 1.0;
  double _nodeIntensity = 0.6;
  double _connectionOpacity = 0.4;
  bool _enableJitter = false;

  @override
  void initState() {
    super.initState();
    _generateNetwork();
    _initializeAnimations();
    _updateForState(widget.emotion.state);
  }

  @override
  void didUpdateWidget(NeuralCompanionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emotion.state != widget.emotion.state) {
      _updateForState(widget.emotion.state);
      _masterController.duration = _getDuration(widget.emotion.state);
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    for (final controller in _pulseControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _generateNetwork() {
    final center = Offset(widget.size / 2, widget.size / 2);
    final nodes = <NeuralNode>[];

    // Layer 1: Center node (largest)
    nodes.add(NeuralNode(
      position: center,
      radius: 4.0,
      baseIntensity: 1.0,
    ));

    // Layer 2: 6 nodes in hexagonal pattern
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final distance = widget.size * 0.25;
      final pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      nodes.add(NeuralNode(
        position: pos,
        radius: 3.5,
        baseIntensity: 0.9,
      ));
    }

    // Layer 3: 12 outer nodes (semi-random)
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) + _random.nextDouble() * 0.3 - 0.15;
      final distance = widget.size * 0.42 + _random.nextDouble() * widget.size * 0.08;
      final pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      nodes.add(NeuralNode(
        position: pos,
        radius: 2.5 + _random.nextDouble() * 0.5,
        baseIntensity: 0.7 + _random.nextDouble() * 0.2,
      ));
    }

    _nodes = nodes;
    _connections = _generateConnections(nodes);
  }

  List<NeuralConnection> _generateConnections(List<NeuralNode> nodes) {
    final connections = <NeuralConnection>[];

    // Connect center to all layer 2 nodes
    for (int i = 1; i <= 6; i++) {
      connections.add(NeuralConnection(
        from: nodes[0],
        to: nodes[i],
        strength: 0.9,
      ));
    }

    // Connect layer 2 nodes to each other (hexagon edges)
    for (int i = 1; i <= 6; i++) {
      final next = (i % 6) + 1;
      connections.add(NeuralConnection(
        from: nodes[i],
        to: nodes[next],
        strength: 0.7,
      ));
    }

    // Connect layer 2 to layer 3 (nearest neighbors)
    for (int i = 7; i < nodes.length; i++) {
      double minDist = double.infinity;
      int nearestIdx = 1;

      for (int j = 1; j <= 6; j++) {
        final dist = (nodes[i].position - nodes[j].position).distance;
        if (dist < minDist) {
          minDist = dist;
          nearestIdx = j;
        }
      }

      connections.add(NeuralConnection(
        from: nodes[nearestIdx],
        to: nodes[i],
        strength: 0.6,
      ));
    }

    // Add some layer 3 to layer 3 connections for complexity
    for (int i = 7; i < nodes.length - 1; i++) {
      if (_random.nextDouble() > 0.6) {
        final targetIdx = 7 + _random.nextInt(nodes.length - 7);
        if (targetIdx != i) {
          connections.add(NeuralConnection(
            from: nodes[i],
            to: nodes[targetIdx],
            strength: 0.4,
          ));
        }
      }
    }

    return connections;
  }

  void _initializeAnimations() {
    _masterController = AnimationController(
      vsync: this,
      duration: _getDuration(widget.emotion.state),
    )..repeat();

    _pulseControllers = List.generate(10, (i) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500 + i * 200),
      );
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          if (_activePulses.length < _activePulseCount) {
            _createPulse(i);
          }
          controller.forward();
        }
      });
      controller.forward();
      return controller;
    });

    _masterController.addListener(() {
      setState(() {});
    });
  }

  void _createPulse(int controllerIdx) {
    if (_connections.isEmpty) return;
    
    final connection = _connections[_random.nextInt(_connections.length)];
    _activePulses.add(SynapsePulse(
      connection: connection,
      progress: 0.0,
      controllerIdx: controllerIdx,
    ));
  }

  void _updateForState(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        _activePulseCount = 2;
        _pulseSpeed = 1.0;
        _nodeIntensity = 0.6;
        _connectionOpacity = 0.4;
        _enableJitter = false;
        break;

      case CompanionState.focused:
        _activePulseCount = 6;
        _pulseSpeed = 2.5;
        _nodeIntensity = 0.9;
        _connectionOpacity = 0.8;
        _enableJitter = false;
        break;

      case CompanionState.alert:
        _activePulseCount = 10;
        _pulseSpeed = 4.0;
        _nodeIntensity = 1.0;
        _connectionOpacity = 0.9;
        _enableJitter = true;
        break;

      case CompanionState.proud:
        _activePulseCount = 8;
        _pulseSpeed = 2.0;
        _nodeIntensity = 1.0;
        _connectionOpacity = 0.95;
        _enableJitter = false;
        break;

      case CompanionState.disappointed:
        _activePulseCount = 1;
        _pulseSpeed = 0.5;
        _nodeIntensity = 0.2;
        _connectionOpacity = 0.3;
        _enableJitter = false;
        break;

      case CompanionState.curious:
        _activePulseCount = 4;
        _pulseSpeed = 1.8;
        _nodeIntensity = 0.75;
        _connectionOpacity = 0.6;
        _enableJitter = false;
        break;

      case CompanionState.sleeping:
        _activePulseCount = 1;
        _pulseSpeed = 0.3;
        _nodeIntensity = 0.15;
        _connectionOpacity = 0.15;
        _enableJitter = false;
        break;
    }
  }

  Duration _getDuration(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const Duration(milliseconds: 3500);
      case CompanionState.focused:
        return const Duration(milliseconds: 1200);
      case CompanionState.alert:
        return const Duration(milliseconds: 500);
      case CompanionState.proud:
        return const Duration(milliseconds: 2500);
      case CompanionState.disappointed:
        return const Duration(milliseconds: 4000);
      case CompanionState.curious:
        return const Duration(milliseconds: 2000);
      case CompanionState.sleeping:
        return const Duration(milliseconds: 4500);
    }
  }

  Color _getStateColor(CompanionState state) {
    switch (state) {
      case CompanionState.idle:
        return const Color(0xFF6CCAFF); // soft ice-blue
      case CompanionState.focused:
        return const Color(0xFF00E7FF); // bright electric cyan
      case CompanionState.alert:
        return const Color(0xFFFF2A4D); // danger red
      case CompanionState.proud:
        return const Color(0xFFFFCA28); // gold
      case CompanionState.disappointed:
        return const Color(0xFF1E2B38); // dim blue-grey
      case CompanionState.curious:
        return const Color(0xFFA37BFF); // purple/blue
      case CompanionState.sleeping:
        return const Color(0xFF0E1220); // deep indigo
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update pulses
    _activePulses.removeWhere((pulse) {
      final controller = _pulseControllers[pulse.controllerIdx];
      return controller.value >= 1.0;
    });

    for (final pulse in _activePulses) {
      final controller = _pulseControllers[pulse.controllerIdx];
      pulse.progress = controller.value * _pulseSpeed;
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: NeuralNetworkPainter(
          nodes: _nodes,
          connections: _connections,
          pulses: _activePulses,
          state: widget.emotion.state,
          animationValue: _masterController.value,
          color: _getStateColor(widget.emotion.state),
          nodeIntensity: _nodeIntensity,
          connectionOpacity: _connectionOpacity,
          enableJitter: _enableJitter,
        ),
      ),
    );
  }
}

/// Data model for a neural node
class NeuralNode {
  final Offset position;
  final double radius;
  final double baseIntensity;

  NeuralNode({
    required this.position,
    required this.radius,
    this.baseIntensity = 1.0,
  });
}

/// Data model for a connection between nodes
class NeuralConnection {
  final NeuralNode from;
  final NeuralNode to;
  final double strength;

  NeuralConnection({
    required this.from,
    required this.to,
    required this.strength,
  });
}

/// Data model for a traveling pulse/synapse
class SynapsePulse {
  final NeuralConnection connection;
  double progress;
  final int controllerIdx;

  SynapsePulse({
    required this.connection,
    required this.progress,
    required this.controllerIdx,
  });

  Offset get position {
    return Offset.lerp(
      connection.from.position,
      connection.to.position,
      progress.clamp(0.0, 1.0),
    )!;
  }
}

/// Custom painter for rendering the neural network
class NeuralNetworkPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final List<NeuralConnection> connections;
  final List<SynapsePulse> pulses;
  final CompanionState state;
  final double animationValue;
  final Color color;
  final double nodeIntensity;
  final double connectionOpacity;
  final bool enableJitter;

  NeuralNetworkPainter({
    required this.nodes,
    required this.connections,
    required this.pulses,
    required this.state,
    required this.animationValue,
    required this.color,
    required this.nodeIntensity,
    required this.connectionOpacity,
    required this.enableJitter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawConnections(canvas);
    _drawNodes(canvas);
    _drawPulses(canvas);
  }

  void _drawConnections(Canvas canvas) {
    for (final connection in connections) {
      final opacity = connectionOpacity * connection.strength;

      // Glow layer
      final glowPaint = Paint()
        ..color = color.withOpacity(opacity * 0.3)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      // Core line
      final linePaint = Paint()
        ..color = color.withOpacity(opacity * 0.8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawLine(connection.from.position, connection.to.position, glowPaint);
      canvas.drawLine(connection.from.position, connection.to.position, linePaint);
    }
  }

  void _drawNodes(Canvas canvas) {
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      
      // Calculate position with optional jitter
      Offset position = node.position;
      if (enableJitter) {
        final jitterX = math.sin(animationValue * math.pi * 4 + i) * 1.5;
        final jitterY = math.cos(animationValue * math.pi * 4 + i * 0.7) * 1.5;
        position = position.translate(jitterX, jitterY);
      }

      // Calculate intensity with breathing effect
      double intensity = nodeIntensity * node.baseIntensity;
      
      if (state == CompanionState.idle || state == CompanionState.sleeping) {
        // Gentle breathing
        intensity *= 0.85 + (math.sin(animationValue * math.pi * 2) * 0.15);
      } else if (state == CompanionState.proud) {
        // Wave effect (left to right)
        final progress = (animationValue + (node.position.dx / 140) * 0.5) % 1.0;
        intensity *= 0.7 + (math.sin(progress * math.pi * 2) * 0.3);
      } else if (state == CompanionState.focused || state == CompanionState.alert) {
        // Rapid pulse
        intensity *= 0.9 + (math.sin(animationValue * math.pi * 4) * 0.1);
      }

      final effectiveRadius = node.radius * (0.9 + intensity * 0.1);

      // Outer glow (largest)
      final outerGlowPaint = Paint()
        ..color = color.withOpacity(intensity * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(position, effectiveRadius * 4, outerGlowPaint);

      // Middle glow
      final middleGlowPaint = Paint()
        ..color = color.withOpacity(intensity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(position, effectiveRadius * 2.5, middleGlowPaint);

      // Core node
      final nodePaint = Paint()
        ..color = color.withOpacity(intensity * 0.9)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position, effectiveRadius, nodePaint);

      // Inner highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(intensity * 0.6);
      canvas.drawCircle(position, effectiveRadius * 0.4, highlightPaint);
    }
  }

  void _drawPulses(Canvas canvas) {
    for (final pulse in pulses) {
      if (pulse.progress < 0 || pulse.progress > 1) continue;

      final position = pulse.position;

      // Outer glow
      final glowPaint = Paint()
        ..color = color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(position, 8, glowPaint);

      // Middle glow
      final middleGlowPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(position, 5, middleGlowPaint);

      // Core pulse
      final pulsePaint = Paint()
        ..color = color.withOpacity(0.95);
      canvas.drawCircle(position, 3, pulsePaint);

      // Bright center
      final centerPaint = Paint()
        ..color = Colors.white.withOpacity(0.8);
      canvas.drawCircle(position, 1.5, centerPaint);
    }
  }

  @override
  bool shouldRepaint(NeuralNetworkPainter oldDelegate) => true;
}

