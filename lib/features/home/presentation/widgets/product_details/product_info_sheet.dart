import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/core/theme/text_styles.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:aurawear/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductInfoSheet extends StatelessWidget {
  final Product product;
  final Color selectedColor;
  final AnimationController animationController;

  const ProductInfoSheet({
    super.key,
    required this.product,
    required this.selectedColor,
    required this.animationController,
  });

  Animation<Offset> _getStaggerAnimation(int index) {
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.4 + (index * 0.1), 1.0, curve: Curves.easeOutQuart),
      ),
    );
  }

  Animation<double> _getOpacityAnimation(int index) {
    return CurvedAnimation(
      parent: animationController,
      curve: Interval(0.4 + (index * 0.1), 1.0, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      product.name,
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (product.is3d)
                      IconButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.threeDViewPath,
                            extra: product,
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
                  product.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black45,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const Spacer(),

            SlideTransition(
              position: _getStaggerAnimation(2),
              child: FadeTransition(
                opacity: _getOpacityAnimation(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${product.name} (${selectedColor.toString()}) added to cart!",
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
    );
  }
}
