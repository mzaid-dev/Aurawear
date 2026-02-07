import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/features/splash/presentation/pages/screen1.dart';
import 'package:aurawear/features/splash/presentation/pages/screen2.dart';
import 'package:aurawear/features/splash/presentation/pages/screen3.dart';
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
                backgroundColor: Colors.white.withOpacity(0.9),
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.black.withOpacity(0.05),
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
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
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
        ],
      ),
    );
  }
}
