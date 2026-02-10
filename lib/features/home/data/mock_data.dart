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
      selectedColor: 1,
      colors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFFFBF00),
        const Color(0xFF2E3641),
        const Color(0xFF707E6C),
      ],
    ),
    Product(
      id: '2',
      name: 'Speakers',
      description: 'High-fidelity audio with spatial sound technology.',
      price: 359.00,
      imagePath: AppAssets.speaker,
      is3d: false,
      selectedColor: 3,
      colors: [
        const Color(0xFF2C528C),
        const Color(0xFFF0C050),
        const Color(0xFFE04E30),
        const Color(0xFF202B38),
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
      selectedColor: 4,
      colors: [
        const Color(0xFFFDBDB5),
        const Color(0xFF44528C),
        const Color(0xFF6B4C85),
        const Color(0xFFD68741),
      ],
    ),
    Product(
      id: '4',
      name: 'Earphones',
      description: 'Compact, light, and powerful.',
      price: 60.00,
      imagePath: AppAssets.earphone,
      is3d: false,
      selectedColor: 1,
      colors: [
        const Color(0xFFFFFFFF),
        const Color(0xFF000000),
        const Color(0xFF4B4B4C),
        const Color(0xFF6093A8),
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
      selectedColor: 2,
      colors: [
        const Color.fromARGB(255, 248, 91, 43),
        const Color(0xFF202B38),
        const Color(0xFF6093A8),
        const Color(0xFF44528C),
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
      selectedColor: 1,
      colors: [const Color(0xFFFFFFFF), const Color(0xFF000000)],
    ),
  ];
}
