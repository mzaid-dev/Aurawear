import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/features/splash/presentation/widgets/particle_painter.dart';
import 'package:flutter/material.dart';
class SplashBackground extends StatelessWidget {
  final AnimationController pulseController;
  final List<Particle> particles;
  const SplashBackground({
    super.key,
    required this.pulseController,
    required this.particles,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: pulseController,
          builder: (context, child) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.width * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryRose.withValues(
                        alpha: 0.15 + (pulseController.value * 0.05),
                      ),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            );
          },
        ),
        CustomPaint(painter: ParticlePainter(particles), size: Size.infinite),
      ],
    );
  }
}
