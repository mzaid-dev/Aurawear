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
            bottom: 120, // Adjusted to fit button below
            left: 26,
            right: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "· LUXURY REIMAGINED ·",
                  style: AppTextStyles.splashSubHeader.copyWith(
                    color: AppColors.mutedRoseText,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Premium\nDesign",
                  style: AppTextStyles.splashHeader,
                ),
                const SizedBox(height: 32),
                BouncyButton(
                  gradientColors: const [AppColors.primaryRose, Colors.white],
                  onTap: () => context.goNamed('home'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "SHOP NOW",
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
