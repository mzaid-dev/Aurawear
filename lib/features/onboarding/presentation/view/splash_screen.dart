import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/features/onboarding/presentation/pages/screen1.dart';
import 'package:aurawear/features/onboarding/presentation/pages/screen2.dart';
import 'package:aurawear/features/onboarding/presentation/pages/screen3.dart';
import 'package:flutter/material.dart';
import 'package:glow_container/glow_container.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late LiquidController _liquidController;
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void initState() {
    _liquidController = LiquidController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: const [Screen1(), Screen2(), Screen3()],
            liquidController: _liquidController,
            waveType: WaveType.liquidReveal,
            onPageChangeCallback: (index) {
              _currentPage.value = index;
            },
          ),

          // Professional Arrival Tag
          Positioned(
            top: 56,
            left: 22,
            child: GlowContainer(
              glowRadius: 8,
              gradientColors: [AppColors.primaryRose, Colors.white],
              rotationDuration: const Duration(seconds: 3),
              glowLocation: GlowLocation.both,
              containerOptions: ContainerOptions(
                width: 140,
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                borderRadius: 25,
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ),
              transitionDuration: const Duration(milliseconds: 250),
              showAnimatedBorder: true,
              child: const Center(
                child: Text(
                  "20 new arrivals 🔥",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),

          // Skip Button
          Positioned(
            top: 56,
            right: 22,
            child: TextButton(
              onPressed: () => context.goNamed('home'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
              child: const Text(
                "SKIP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Dot Indicator Overlay
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, currentPage, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final isActive = currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // Swipe Guidance Arrow (Visible only on first 2 pages)
          Positioned(
            bottom: 150,
            right: 20,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, currentPage, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: currentPage < 2 ? 1.0 : 0.0,
                  child: const _SwipeArrow(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeArrow extends StatefulWidget {
  const _SwipeArrow();

  @override
  State<_SwipeArrow> createState() => _SwipeArrowState();
}

class _SwipeArrowState extends State<_SwipeArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _slideAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                const Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  color: Colors.white,
                  size: 32,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "SWIPE",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
