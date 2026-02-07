import 'package:aurawear/core/common_widgets/bouncy_button.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isSmall;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: onTap,
      gradientColors: const [AppColors.gradientStart, AppColors.gradientEnd],
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 16 : 32,
          vertical: isSmall ? 8 : 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSmall ? text : text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 12 : 16,
                letterSpacing: isSmall ? 1.0 : 0.5,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: isSmall ? 16 : 20),
            ],
          ],
        ),
      ),
    );
  }
}
