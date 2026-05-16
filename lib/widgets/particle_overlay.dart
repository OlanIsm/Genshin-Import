import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class Particle {
  double x, y, size, speed, opacity;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}

/// Floating magical particle overlay widget
class ParticleOverlay extends StatefulWidget {
  final int count;
  const ParticleOverlay({super.key, this.count = 30});

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final _rng = Random();

  static const _colors = [
    AppColors.gold,
    AppColors.hydro,
    AppColors.electro,
    AppColors.anemo,
    AppColors.goldLight,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _particles = List.generate(widget.count, (_) => _randomParticle());
  }

  Particle _randomParticle() => Particle(
    x: _rng.nextDouble(),
    y: _rng.nextDouble(),
    size: 1.5 + _rng.nextDouble() * 3,
    speed: 0.003 + _rng.nextDouble() * 0.007,
    opacity: 0.1 + _rng.nextDouble() * 0.5,
    color: _colors[_rng.nextInt(_colors.length)],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        for (final p in _particles) {
          p.y -= p.speed * _controller.value * 0.1;
          if (p.y < -0.05) {
            p.y = 1.05;
            p.x = _rng.nextDouble();
          }
        }
        return IgnorePointer(
          child: CustomPaint(
            painter: _ParticlePainter(_particles),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withAlpha((p.opacity * 255).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}
