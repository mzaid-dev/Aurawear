import 'package:flutter/material.dart';

/// App color palette based on the "Dusty Rose" design aesthetic.
class AppColors {
  AppColors._();

  // Primary Colors (from the headphones and accents)
  static const Color primaryRose = Color(0xFFE35858);
  static const Color primaryRoseLight = Color(0xFFFEE1DD);
  static const Color primaryRoseDark = Color(0xFFC04848);

  // Gradient Colors (from spec)
  static const Color gradientStart = Color(0xFFC3332D);
  static const Color gradientEnd = Color(0xFFE6C3BD);

  // Muted Design Colors
  static const Color mutedRoseText = Color(0xFFF89890);

  // Home Screen Colors
  static const Color homeBg = Color(0xFFFAF1EF);
  static const Color chipInactive = Color(0xFFFBE8E5);
  static const Color chipActive = Colors.black;
  static const Color searchIcon = Color(0xFFB4A19F);
  static const Color iconBg = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFEE1DD);
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textBlack = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFAAAAAA);
  static const Color textWhite = Colors.white;

  // Accent Colors
  static const Color accentDark = Color(0xFF1A1A1A);
  static const Color accentRose = Color(0xFFE35858);

  // Functional Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);

  // Shadows & Overlays
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color overlay = Colors.black.withValues(alpha: 0.4);
}
