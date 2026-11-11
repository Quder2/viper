import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A lightweight animated layer of toxic-green particles.
/// Place it inside a Stack and wrap it with IgnorePointer.
class ToxicParticles extends StatefulWidget {
  const ToxicParticles({
    super.key,
    this.particleCount = 22,
    this.opacity = 0.24,
    this.color = const Color(0xFF73FF55),
  });

  final int particleCount;
  final double opacity;
  final Color color;

  @override
  State<ToxicParticles> createState() => _ToxicParticlesState();
}

class _ToxicParticlesState extends State<ToxicParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ToxicParticlesPainter(
            animation: _controller,
            particleCount: widget.particleCount,
            opacity: widget.opacity,
            color: widget.color,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ToxicParticlesPainter extends CustomPainter {
  _ToxicParticlesPainter({
    required this.animation,
    required this.particleCount,
    required this.opacity,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int particleCount;
  final double opacity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final progress = animation.value;
    final paint = Paint()
      ..color = color
      ..blendMode = BlendMode.plus;

    for (var i = 0; i < particleCount; i++) {
      final seed = i * 137.508;
      final startX = ((seed * 0.6180339887) % 1.0) * size.width;
      final startY = ((seed * 0.3819660113) % 1.0) * size.height;
      final drift = math.sin((progress * math.pi * 2) + i) * 18;
      final rise = (progress * (size.height + 36) + startY) %
          (size.height + 36);
      final radius = 1.2 + (i % 4) * 0.65;
      final pulse = 0.55 + 0.45 * math.sin(progress * math.pi * 2 + i);
      final particleOpacity =
          (opacity * pulse).clamp(0.0, 1.0).toDouble();

      paint.color = color.withValues(alpha: particleOpacity);
      canvas.drawCircle(
        Offset((startX + drift) % size.width, size.height - rise),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ToxicParticlesPainter oldDelegate) {
    return oldDelegate.particleCount != particleCount ||
        oldDelegate.opacity != opacity ||
        oldDelegate.color != color;
  }
}
