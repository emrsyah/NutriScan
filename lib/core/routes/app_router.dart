import 'package:nutriscan/features/foods/presentation/pages/food_detail_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final app_router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'food_details',
      path: '/food',
      builder: (context, state) => FoodDetailsPage(),
    ),
  ],
);