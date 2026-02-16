import 'package:flutter/material.dart';
import 'onboarding_page_one.dart';
import 'onboarding_page_two.dart';
import 'onboarding_page_three.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:aurawear/core/theme/index.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LiquidController _liquidController = LiquidController();
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: [
              OnboardingPageOne(),
              OnboardingPageTwo(),
              OnboardingPageThree(),
            ],
            liquidController: _liquidController,
            onPageChangeCallback: (page) {
              setState(() {
                this.page = page;
              });
            },
            slideIconWidget: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            fullTransitionValue: 880,
            enableSideReveal: true,
            enableLoop: false,
            positionSlideIcon: 0.8,
            waveType: WaveType.liquidReveal,
            ignoreUserGestureWhileAnimating: true,
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildDot(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    double size = page == index ? 25 : 8;
    Color color = page == index ? AppColors.primaryRose : Colors.grey;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
