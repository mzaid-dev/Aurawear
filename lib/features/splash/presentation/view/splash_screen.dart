import 'dart:async';
import 'package:aurawear/core/router/app_routes.dart';
import 'package:aurawear/features/splash/presentation/widgets/particle_painter.dart';
import 'package:aurawear/features/splash/presentation/widgets/splash_background.dart';
import 'package:aurawear/features/splash/presentation/widgets/splash_content.dart';
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
  late AnimationController _exitController;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  late AnimationController _mainController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _textSpacing;

  final List<Particle> _particles = [];
  Timer? _particleTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _exitScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInCubic),
    );

    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSpacing = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    for (int i = 0; i < 20; i++) {
      _particles.add(Particle());
    }

    _particleTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });

    _startSequence();
  }

  void _startSequence() async {
    await _mainController.forward();
    if (!mounted) return;
    await _exitController.forward();
    if (!mounted) return;
    context.goNamed(AppRoutes.onboardingName);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ensure a solid black background exists behind everything
          Container(color: Colors.black),
          AnimatedBuilder(
            animation: _exitController,
            builder: (context, child) {
              return Opacity(
                opacity:
                    _exitController.isAnimating || _exitController.isCompleted
                    ? _exitOpacity.value
                    : 1.0,
                child: Transform.scale(
                  scale:
                      _exitController.isAnimating || _exitController.isCompleted
                      ? _exitScale.value
                      : 1.0,
                  child: Stack(
                    children: [
                      SplashBackground(
                        pulseController: _pulseController,
                        particles: _particles,
                      ),
                      SplashContent(
                        mainController: _mainController,
                        pulseController: _pulseController,
                        logoScale: _logoScale,
                        contentOpacity: _contentOpacity,
                        textSpacing: _textSpacing,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
