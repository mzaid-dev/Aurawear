import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:aurawear/core/theme/app_colors.dart';
class Particle {
  double x = 0;
  double y = 0;
  double speed = 0;
  double opacity = 0;
  double size = 0;
  final math.Random _random = math.Random();
  Particle() {
    reset(true);
  }
  void reset(bool startRandom) {
    x = _random.nextDouble();
    y = startRandom ? _random.nextDouble() : 1.2;
    speed = 0.001 + _random.nextDouble() * 0.002;
    opacity = 0.1 + _random.nextDouble() * 0.4;
    size = 1.0 + _random.nextDouble() * 2.0;
  }
  void update() {
    y -= speed;
    if (y < -0.2) {
      reset(false);
    }
  }
}
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var particle in particles) {
      paint.color = AppColors.primaryRose.withValues(alpha: particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
