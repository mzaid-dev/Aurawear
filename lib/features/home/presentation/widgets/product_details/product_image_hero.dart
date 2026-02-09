import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:flutter/material.dart';

class ProductImageHero extends StatelessWidget {
  final Product product;

  const ProductImageHero({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Hero(
        tag: 'product_image_${product.id}',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Image.asset(product.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
