import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:riverpod/riverpod.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository();
});


