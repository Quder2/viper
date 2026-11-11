import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:viper/theme/sage_theme.dart';

/// Soft snowfall and radiant ice crystals for Sage's visual identity.
class SageParticles extends StatefulWidget {
  const SageParticles({
    super.key,
    this.count = 30,
    this.opacity = .34,
  });

  final int count;
  final double opacity;

  @override
  State<SageParticles> createState() => _SageParticlesState();
}

class _SageParticlesState extends State<SageParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _SageParticlesPainter(
              animation: _controller,
              count: widget.count,
              opacity: widget.opacity,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      );
}

class _SageParticlesPainter extends CustomPainter {
  _SageParticlesPainter({
    required this.animation,
    required this.count,
    required this.opacity,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int count;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final progress = animation.value;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.plus;

    for (var i = 0; i < count; i++) {
      final seed = i * 137.508;
      final x = ((seed * .6180339887) % 1) * size.width;
      final startY = ((seed * .3819660113) % 1) * size.height;
      final drift = math.sin(progress * math.pi * 2 + i * .7) * (9 + i % 8);
      final fall = (progress * (size.height + 30) + startY) %
          (size.height + 30);
      final y = size.height - fall;
      final pulse = .45 + .55 * math.sin(progress * math.pi * 2 + i).abs();
      final alpha = (opacity * pulse * (i % 5 == 0 ? 1 : .68))
          .clamp(0.0, 1.0)
          .toDouble();
      paint.color = (i % 6 == 0 ? SageTheme.jade : SageTheme.ice)
          .withValues(alpha: alpha);

      if (i % 6 == 0) {
        final radius = 2.2 + (i % 3) * .55;
        final path = Path()
          ..moveTo(x + drift, y - radius * 2)
          ..lineTo(x + drift + radius * .55, y)
          ..lineTo(x + drift, y + radius * 2)
          ..lineTo(x + drift - radius * .55, y)
          ..close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(
          Offset(x + drift, y),
          .8 + (i % 3) * .55,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SageParticlesPainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.opacity != opacity;
}
