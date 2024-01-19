import 'package:nutriscan/features/foods/data/meal_repository.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_repository_providers.dart';
import 'package:riverpod/riverpod.dart';

final FutureHomeFoodController =
    FutureProvider.family<List<Meal>, Map<String, dynamic>>((ref, excludeTags) async {
  final mealRepository = ref.read(mealRepositoryProvider);
  return mealRepository.getFoods(generateAllergyString(excludeTags));
});

String generateAllergyString(Map<String, dynamic> allergies) {
  // Filter out items with status "NO"
  final noAllergies = allergies.entries.where((entry) => entry.value == "NO").map((e) => e.key);

  // Process each "NO" item according to your rules
  final processedAllergies = noAllergies.map((allergy) {
    switch (allergy) {
      case "Seafood":
        return "seafood";
      case "Milk, Eggs, Other Dairy":
        return "milk,eggs,dairy";
      case "Meat":
        return "meat";
      case "Nut":
        return "nut,peanut";
      case "Bakery/Bread":
        return "wheat,gluten,grain,bread";
      case "Nut butters, Jams, and Honey":
        return "honey,nut,peanut";
      // Add more cases for other allergies if needed
      default:
        return "";
    }
  });

  // Combine the processed allergies into a single string
  final result = processedAllergies.join(',');

  return result;
}

// final HomeFoodsProvider =
//     FutureProvider.family<List<Meal>, String>((ref, excludeTags) async {
//   final mealRepository = ref.read(mealRepositoryProvider);
//   // return mealRepository.getFoodScanDetail(id);
// });

// Approach:
// 1. Buat State Notifier buat controllernya (MealController), dia ini make si repository
// 2. ngebuat provider si state notifier controllernya (mealControllerProvider)
