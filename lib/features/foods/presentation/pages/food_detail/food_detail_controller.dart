import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:nutriscan/features/foods/domain/meal_detail.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_repository_providers.dart';
import 'package:riverpod/riverpod.dart';


class FoodDetailController extends StateNotifier<MealDetail?> {
  final MealRepository _mealRepository;

  FoodDetailController(this._mealRepository) : super(null); // Initialize with an empty MealDetail

  Future<void> getFoodDetails(int foodId) async {
    try {
      // Fetch meal details from the repository
      // print(foodId);
      final mealDetails = await _mealRepository.getFoodDetails(foodId);
      // Update the state with the fetched details
      state = mealDetails;
    } catch (error) {
      // Handle errors
      print("Error fetching meal details: $error");
    }
  }
}

final foodDetailControllerProvider = StateNotifierProvider<FoodDetailController, MealDetail?>(
  (ref) => FoodDetailController(ref.read(mealRepositoryProvider)),
);

final FutureFoodDetailController =
    FutureProvider.family<MealDetail, int>((ref, id) async {
  final mealRepository = ref.read(mealRepositoryProvider);
  return mealRepository.getFoodDetails(id);
});
