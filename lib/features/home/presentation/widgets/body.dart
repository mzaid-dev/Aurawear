import 'package:aurawear/core/theme/text_styles.dart';
import 'package:aurawear/features/home/data/mock_data.dart';
import 'package:aurawear/features/home/presentation/widgets/categories_tab_bar.dart';
import 'package:aurawear/features/home/presentation/widgets/product_tile.dart';
import 'package:aurawear/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _staggerController.forward();
  }

  Animation<Offset> _getCartBarAnimation() {
    return Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          color: Color(0xffFFE7E4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                SizedBox(height: 46),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "New\narrivals",
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tab Bar
                const CustomChipTabBar(),
                const SizedBox(height: 24),

                // Product Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 100,
                    ), // Space for FAB
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: MockData.products.length,
                    itemBuilder: (context, index) {
                      final animation = CurvedAnimation(
                        parent: _staggerController,
                        curve: Interval(
                          (index / MockData.products.length).clamp(0.0, 1.0),
                          1.0,
                          curve: Curves.easeOutQuart,
                        ),
                      );

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: ProductTile(
                            product: MockData.products[index],
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.productDetailsName,
                                extra: MockData.products[index],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 30,
              child: SlideTransition(
                position: _getCartBarAnimation(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  width: 138,
                  height: 45.14,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(22.57),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 18),
                      const Text(
                        "\$1080.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_sharp,
                              color: Colors.black,
                              size: 20,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE35858),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "1",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
