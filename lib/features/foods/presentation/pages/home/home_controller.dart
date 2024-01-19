import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_repository_providers.dart';
import 'package:riverpod/riverpod.dart';

class MealController extends StateNotifier<List<Meal>> {
  final MealRepository _mealRepository;

  MealController(this._mealRepository) : super([]);

  Future<void> getFoods() async {
    try {
      final meals = await _mealRepository.getFoods();
      // print(meals[0].mealInfo.labels.length);
      state = meals;
    } catch (error) {
      // Handle errors
      print("Error fetching meals: $error");
    }
  }

}

final mealControllerProvider =
    StateNotifierProvider<MealController, List<Meal>>(
  (ref) => MealController(ref.read(mealRepositoryProvider)),
);

// final HomeFoodsProvider =
//     FutureProvider.family<List<Meal>, String>((ref, excludeTags) async {
//   final mealRepository = ref.read(mealRepositoryProvider);
//   // return mealRepository.getFoodScanDetail(id);
// });

// Approach:
// 1. Buat State Notifier buat controllernya (MealController), dia ini make si repository
// 2. ngebuat provider si state notifier controllernya (mealControllerProvider)
