import 'package:nutriscan/features/foods/domain/meal_detail.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_repository_providers.dart';
import 'package:riverpod/riverpod.dart';

final FutureFoodDetailController =
    FutureProvider.family<MealDetail, int>((ref, id) async {
  final mealRepository = ref.read(mealRepositoryProvider);
  return mealRepository.getFoodDetails(id);
});
