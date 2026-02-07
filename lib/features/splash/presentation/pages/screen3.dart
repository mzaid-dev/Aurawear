import 'package:aurawear/core/common_widgets/bouncy_button.dart';
import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppAssets.splashBackground3, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 170, // Standardized professional alignment
            left: 26,
            right: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "· THE FUTURE OF AUDIO ·",
                  style: AppTextStyles.splashSubHeader.copyWith(
                    color: AppColors.mutedRoseText,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text("360°\nSound", style: AppTextStyles.splashHeader),
                SizedBox(height: 24),
                BouncyButton(
                  onTap: () => context.goNamed('home'),
                  gradientColors: const [
                    Color(0xFFC3332D), // Branded Gradient Start
                    Color(0xFFE6C3BD), // Branded Gradient End
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Shop Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 7.9),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated Bouncy Shop Now Button
        ],
      ),
    );
  }
}
