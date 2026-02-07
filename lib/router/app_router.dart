import 'package:aurawear/core/common_widgets/model_viewer.dart';
import 'package:aurawear/features/home/domain/models/product.dart';
import 'package:aurawear/features/home/presentation/pages/home_page.dart';
import 'package:aurawear/features/home/presentation/pages/product_details_page.dart';
import 'package:aurawear/features/onboarding/presentation/view/splash_screen.dart'
    as onboarding;
import 'package:aurawear/features/splash/presentation/view/splash_screen.dart'
    as splash;
import 'package:aurawear/router/app_routes.dart';
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
      builder: (context, state) => const onboarding.SplashScreen(),
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
