import 'dart:async';
import 'dart:math' as math;
import 'package:aurawear/core/constants/app_assets.dart';
import 'package:aurawear/core/theme/app_colors.dart';
import 'package:aurawear/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String _phase = 'logo';
  double _progress = 0;
  late Timer _phaseTimer1;
  late Timer _phaseTimer2;
  late Timer _progressTimer;

  late AnimationController _scanlineController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _phaseTimer1 = Timer(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _phase = 'text');
    });

    _phaseTimer2 = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _phase = 'loading');
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      if (_phase == 'loading') {
        setState(() {
          if (_progress >= 100) {
            _progress = 100;
            timer.cancel();
            _checkAndExit();
          } else {
            // Simulated progress logic without AuthBloc
            _progress += math.Random().nextDouble() * 10;
            if (_progress > 100) _progress = 100;
          }
        });
      }
    });
  }

  void _checkAndExit() {
    if (_progress >= 100) {
      setState(() => _phase = 'exit');

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          context.goNamed(AppRoutes.onboardingName);
        }
      });
    }
  }

  @override
  void dispose() {
    _phaseTimer1.cancel();
    _phaseTimer2.cancel();
    _progressTimer.cancel();
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: _buildBody());
  }

  Widget _buildBody() {
    final bool isExit = _phase == 'exit';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isExit ? 0.0 : 1.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 800),
        scale: isExit ? 1.1 : 1.0,
        curve: Curves.easeOutQuart,
        child: Stack(
          children: [
            // Background Glow
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRose.withValues(alpha: 0.12),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),

            // Scanline animation
            AnimatedBuilder(
              animation: _scanlineController,
              builder: (context, child) {
                return Positioned(
                  top:
                      MediaQuery.sizeOf(context).height *
                      _scanlineController.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.primaryRose.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: const Cubic(0.2, 0.8, 0.2, 1.0),
                    width: 130,
                    height: 130,
                    transform: Matrix4.translationValues(
                      0,
                      _phase == 'logo' ? 40 : 0,
                      0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRose.withValues(alpha: 0.15),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const _PulseGlow(),
                          Opacity(
                            opacity: _phase == 'logo' ? 0.0 : 1.0,
                            child: Image.asset(
                              AppAssets.appLogo,
                              width: 80,
                              height: 80,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.auto_awesome_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title & Tagline
                  ClipRect(
                    child: _AnimatedTitle(
                      visible: _phase != 'logo',
                      title: "Aurawear",
                      tagline: "LUXURY REIMAGINED",
                    ),
                  ),
                ],
              ),
            ),

            // Progress Section
            Positioned(
              bottom: 110,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 700),
                opacity: _phase == 'loading' || _phase == 'exit' ? 1.0 : 0.0,
                child: Center(
                  child: SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "INITIALIZING SYSTEMS",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.2),
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              "${_progress.toInt()}%",
                              style: const TextStyle(
                                color: AppColors.primaryRose,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Custom Linear Progress
                        Container(
                          height: 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progress / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.primaryRose, Colors.white],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRose.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "AURA PROTOCOL V1.0.1",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.1),
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
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

class _PulseGlow extends StatefulWidget {
  const _PulseGlow();

  @override
  State<_PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<_PulseGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.05, end: 0.2).animate(_controller),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.primaryRose, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _AnimatedTitle extends StatelessWidget {
  final bool visible;
  final String title;
  final String tagline;

  const _AnimatedTitle({
    required this.visible,
    required this.title,
    required this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, visible ? 0 : 25, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: visible ? 1.0 : 0.0,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFFCCCCCC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, visible ? 0 : 15, 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: visible ? 1.0 : 0.0,
            child: Text(
              tagline,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
