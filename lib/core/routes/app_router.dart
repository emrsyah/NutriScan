import 'package:nutriscan/features/auth/presentation/sign_in_page.dart';
import 'package:nutriscan/features/auth/presentation/sign_up_page.dart';
import 'package:nutriscan/features/common/presentation/pages/splash_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final app_router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      name: 'sign-in',
      path: '/sign-in',
      builder: (context, state) => SignInPage(),
    ),
    GoRoute(
      name: 'sign-up',
      path: '/sign-up',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'food_details',
      path: '/food/:id',
      builder: (context, state) =>
          FoodDetailsPage(foodId: int.parse(state.pathParameters["id"] ?? "1")),
    ),
  ],
);