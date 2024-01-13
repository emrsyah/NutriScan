import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_controller.dart';
import 'package:riverpod/riverpod.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository();
});

final mealControllerProvider = StateNotifierProvider<MealController, List<Meal>>(
  (ref) => MealController(
    ref.read(mealRepositoryProvider),
  ),
);
