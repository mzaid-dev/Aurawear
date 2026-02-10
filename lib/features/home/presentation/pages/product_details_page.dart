import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:aurawear/features/home/presentation/widgets/product_details/color_selector.dart';
import 'package:aurawear/features/home/presentation/widgets/product_details/product_image_hero.dart';
import 'package:aurawear/features/home/presentation/widgets/product_details/product_info_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}
class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late Color selectedColor;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    selectedColor = widget.product.colors.first;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            ProductImageHero(product: widget.product),
            ColorSelector(
              colors: widget.product.colors,
              selectedColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            ProductInfoSheet(
              product: widget.product,
              selectedColor: selectedColor,
              animationController: _animationController,
            ),
          ],
        ),
      ),
    );
  }
}
