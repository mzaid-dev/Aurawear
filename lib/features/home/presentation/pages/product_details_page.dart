import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:aurawear/router/app_routes.dart';
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

  Animation<Offset> _getStaggerAnimation(int index) {
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4 + (index * 0.1), 1.0, curve: Curves.easeOutQuart),
      ),
    );
  }

  Animation<double> _getOpacityAnimation(int index) {
    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4 + (index * 0.1), 1.0, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
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

            // Hero Image Section
            Expanded(
              flex: 4,
              child: Hero(
                tag: 'product_image_${widget.product.id}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Color Selectors Container
            Container(
              height: 74.88,
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.product.colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: _buildColorDot(
                      color,
                      isSelected: selectedColor == color,
                    ),
                  );
                }).toList(),
              ),
            ),

            // Bottom Content Container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                decoration: const BoxDecoration(
                  color: Color(0xffFFE7E4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideTransition(
                      position: _getStaggerAnimation(0),
                      child: FadeTransition(
                        opacity: _getOpacityAnimation(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.name,
                              style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                            if (widget.product.is3d)
                              IconButton(
                                onPressed: () {
                                  context.push(
                                    AppRoutes.threeDViewPath,
                                    extra: widget.product,
                                  );
                                },
                                icon: const Icon(
                                  Icons.threed_rotation_sharp,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SlideTransition(
                      position: _getStaggerAnimation(1),
                      child: FadeTransition(
                        opacity: _getOpacityAnimation(1),
                        child: Text(
                          widget.product.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.black45,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Price and Add to Cart Button
                    SlideTransition(
                      position: _getStaggerAnimation(2),
                      child: FadeTransition(
                        opacity: _getOpacityAnimation(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: AppTextStyles.headlineLarge.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Add to cart logic
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${widget.product.name} (${selectedColor.toString()}) added to cart!",
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: AppColors.primaryRose,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDBDB5),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Add to cart",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.shopping_cart_sharp,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, {bool isSelected = false}) {
    return AnimatedScale(
      scale: isSelected ? 1.1 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 44,
        width: 44,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 8),
        ),
      ),
    );
  }
}
