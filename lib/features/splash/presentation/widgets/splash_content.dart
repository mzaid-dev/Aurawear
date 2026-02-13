import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final AnimationController mainController;
  final AnimationController pulseController;
  final Animation<double> logoScale;
  final Animation<double> contentOpacity;
  final Animation<double> textSpacing;

  const SplashContent({
    super.key,
    required this.mainController,
    required this.pulseController,
    required this.logoScale,
    required this.contentOpacity,
    required this.textSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: mainController,
        builder: (context, child) {
          return Opacity(
            opacity: contentOpacity.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: pulseController,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: logoScale.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRose.withValues(
                                alpha: 0.2,
                              ),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppAssets.appLogo,
                          width: 140,
                          height: 140,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "AURAWEAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: textSpacing.value,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "LUXURY REIMAGINED",
                  style: TextStyle(
                    color: AppColors.primaryRose.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
