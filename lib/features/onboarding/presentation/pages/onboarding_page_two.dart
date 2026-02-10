import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppAssets.splashBackground2, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 170,
            left: 26,
            right: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "· IMMERSIVE EXPERIENCE ·",
                  style: AppTextStyles.splashSubHeader.copyWith(
                    color: AppColors.mutedRoseText,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Next-Gen\nAudio",
                  style: AppTextStyles.splashHeader,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
