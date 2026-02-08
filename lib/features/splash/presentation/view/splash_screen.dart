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
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late Animation<double> _logoScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _textSpacing;

  final List<_Particle> _particles = [];
  Timer? _particleTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Continuous breathing animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

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

    // Initialize particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle());
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

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    context.goNamed(AppRoutes.onboardingName);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Ambient Background Pulse
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.5,
                  height: MediaQuery.of(context).size.width * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryRose.withValues(
                          alpha: 0.15 + (_pulseController.value * 0.05),
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. Floating Particles
          CustomPaint(
            painter: _ParticlePainter(_particles),
            size: Size.infinite,
          ),

          // 3. Main Content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentOpacity.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating orbital ring
                          RotationTransition(
                            turns: _pulseController,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          // App Logo
                          Transform.scale(
                            scale: _logoScale.value,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryRose.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                AppAssets.appLogo,
                                width: 140,
                                height: 140,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Elegant Typography
                      Text(
                        "AURAWEAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: _textSpacing.value,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "LUXURY REIMAGINED",
                        style: TextStyle(
                          color: AppColors.primaryRose.withValues(alpha: 0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Particle System Classes ---

class _Particle {
  double x = 0;
  double y = 0;
  double speed = 0;
  double opacity = 0;
  double size = 0;
  final math.Random _random = math.Random();

  _Particle() {
    reset(true);
  }

  void reset(bool startRandom) {
    x = _random.nextDouble();
    y = startRandom ? _random.nextDouble() : 1.2;
    speed = 0.001 + _random.nextDouble() * 0.002;
    opacity = 0.1 + _random.nextDouble() * 0.4;
    size = 1.0 + _random.nextDouble() * 2.0;
  }

  void update() {
    y -= speed;
    if (y < -0.2) {
      reset(false);
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      paint.color = AppColors.primaryRose.withValues(alpha: particle.opacity);
      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
