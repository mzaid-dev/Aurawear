import 'package:flutter/material.dart';
import 'package:aurawear/core/common_widgets/model_viewer.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:aurawear/features/home/presentation/pages/home_page.dart';
import 'package:aurawear/features/home/presentation/pages/product_details_page.dart';
import 'package:aurawear/features/onboarding/presentation/pages/onboarding_screen.dart'
    as onboarding;
import 'package:aurawear/features/splash/presentation/view/splash_screen.dart'
    as splash;
import 'package:aurawear/core/router/app_routes.dart';
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
