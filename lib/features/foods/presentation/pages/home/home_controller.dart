import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_providers.dart';
import 'package:riverpod/riverpod.dart';

class MealController extends StateNotifier<List<Meal>> {
  final MealRepository _mealRepository;

  MealController(this._mealRepository) : super([]);

  Future<void> getFoods() async {
    try {
      final meals = await _mealRepository.getFoods();
      state = meals;
    } catch (error) {
      // Handle errors
      print("Error fetching meals: $error");
    }
  }
}

final mealControllerProvider = StateNotifierProvider<MealController, List<Meal>>(
  (ref) => MealController(ref.read(mealRepositoryProvider)),
);
