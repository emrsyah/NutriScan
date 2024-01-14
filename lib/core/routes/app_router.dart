import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final app_router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
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