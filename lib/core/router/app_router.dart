import 'package:aurawear/core/common_widgets/index.dart';
import 'package:aurawear/features/home/domain/home_domain.dart';
import 'package:aurawear/features/home/presentation/home_presentation.dart';
import 'package:aurawear/features/onboarding/presentation/onboarding_presentation.dart'
    as onboarding;
import 'package:aurawear/features/splash/presentation/splash_presentation.dart'
    as splash;
import 'package:aurawear/core/router/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splashPath,
  routes: [
    GoRoute(
      path: AppRoutes.splashPath,
      name: AppRoutes.splashName,
      builder: (context, state) => const splash.SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboardingPath,
      name: AppRoutes.onboardingName,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const onboarding.OnboardingScreen(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.homePath,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.productDetailsPath,
      name: AppRoutes.productDetailsName,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsPage(product: product);
      },
    ),
    GoRoute(
      path: AppRoutes.threeDViewPath,
      name: AppRoutes.threeDViewName,
      builder: (context, state) {
        final product = state.extra as Product;
        return ModelViewerWidget(product: product);
      },
    ),
  ],
);
