import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/features/home/domain/models/product.dart';

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
    ),
    Product(
      id: '2',
      name: 'Speakers',
      description: 'High-fidelity audio with spatial sound technology.',
      price: 359.00,
      imagePath: AppAssets.speaker,
      is3d: false,
      
    ),
    Product(
      id: '3',
      name: 'Headphones',
      description: 'Precision crafted for the ultimate sonic experience.',
      price: 650.00,
      imagePath: AppAssets.headphone,
      is3d: true,
      modelPath: AppAssets.headphoneModel,
    ),
    Product(
      id: '4',
      name: 'Earphones',
      description: 'Compact, light, and powerful.',
      price: 60.00,
      imagePath: AppAssets.earphone,
      is3d: false,
    ),
  ];
}
