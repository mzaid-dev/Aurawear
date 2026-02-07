import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppAssets.splashBackground1, fit: BoxFit.cover),
          ),

          Positioned(
            bottom: 170, // Standardized professional alignment
            left: 26,
            right: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "· PRECISION CRAFTED ·",
                  style: AppTextStyles.splashSubHeader.copyWith(
                    color: AppColors.mutedRoseText,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Iconic\nDesign", style: AppTextStyles.splashHeader),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
