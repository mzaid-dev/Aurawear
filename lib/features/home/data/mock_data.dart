import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:flutter/material.dart';

class MockData {
  static List<Product> get products => [
    Product(
      id: '1',
      name: 'Airpods Pro',
      description:
          'A mesh textile wraps the ear cushions to provide pillow-like softness.',
      price: 499.00,
      imagePath: AppAssets.airpodPro,
      is3d: true,
      modelPath: AppAssets.airpodProModel,
      colors: [
        const Color(0xFFF2D0CB), // Rose
        const Color(0xFFE5E5E5), // Silver
        const Color(0xFF333333), // Space Gray
        const Color(0xFFD4AF37), // Gold
      ],
    ),
    Product(
      id: '2',
      name: 'Speakers',
      description: 'High-fidelity audio with spatial sound technology.',
      price: 359.00,
      imagePath: AppAssets.speaker,
      is3d: false,
      colors: [
        const Color(0xFF000000), // Black
        const Color(0xFFFFFFFF), // White
        const Color(0xFF4A4A4A), // Gray
        const Color(0xFF1B4F72), // Blue
      ],
    ),
    Product(
      id: '3',
      name: 'Headphones',
      description: 'Precision crafted for the ultimate sonic experience.',
      price: 650.00,
      imagePath: AppAssets.headphone,
      is3d: true,
      modelPath: AppAssets.headphoneModel,
      colors: [
        const Color(0xFFF2D0CB), // Rose
        const Color(0xFF1C1C1E), // Mid Night
        const Color(0xFFFAFAFA), // Starlight
        const Color(0xFFB9E5E8), // Sky Blue
      ],
    ),
    Product(
      id: '4',
      name: 'Earphones',
      description: 'Compact, light, and powerful.',
      price: 60.00,
      imagePath: AppAssets.earphone,
      is3d: false,
      colors: [
        const Color(0xFFFDBDB5), // Coral
        const Color(0xFF2C3E50), // Navy
        const Color(0xFF95A5A6), // Concrete
        const Color(0xFF27AE60), // Green
      ],
    ),
    Product(
      id: '5',
      name: 'Apple Watch Ultra',
      description: 'The most rugged and capable Apple Watch ever.',
      price: 799.00,
      imagePath: AppAssets.watch,
      is3d: true,
      modelPath: AppAssets.appleWatchModel,
      colors: [
        const Color(0xFFE2E2E2), // Titanium
        const Color(0xFFEF6C00), // Orange
        const Color(0xFF1B5E20), // Green
        const Color(0xFF01579B), // Blue
      ],
    ),
    Product(
      id: '6',
      name: 'Apple Vision Pro',
      description: 'Welcome to the era of spatial computing.',
      price: 3499.00,
      imagePath: AppAssets.visionPro,
      is3d: true,
      modelPath: AppAssets.visionModel,
      colors: [
        const Color(0xFFC0C0C0), // Silver
        const Color(0xFF424242), // Charcoal
        const Color(0xFFE0E0E0), // White
        const Color(0xFF7986CB), // Indigo
      ],
    ),
  ];
}
