import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // Header Icons
          Positioned(
            top: 56,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.more_vert, color: AppColors.textBlack),
                const Icon(Icons.menu, color: AppColors.textBlack),
              ],
            ),
          ),

          // Main Product Image
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Hero(
              tag: 'product_3', // Matching mock data ID
              child: Image.asset(
                AppAssets.splashBackground3,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Color Selectors
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildColorDot(const Color(0xFF0D234A), isSelected: true),
                _buildColorDot(const Color(0xFF388E3C)),
                _buildColorDot(const Color(0xFFE6C3BD)),
                _buildColorDot(const Color(0xFFE35858)),
              ],
            ),
          ),

          // Detail Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Apple\nAirpods",
                    style: AppTextStyles.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "A mesh textile wraps the ear cushions to provide pillow-like softness.",
                    style: AppTextStyles.bodyMuted,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "\$499.00",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRoseLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Add to cart",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.shopping_bag, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: AppColors.primaryRose, width: 2)
            : null,
      ),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
