import 'package:nutriscan/features/foods/domain/food_scan.dart';
import 'package:nutriscan/features/foods/domain/food_scan_detail.dart';
import 'package:nutriscan/features/foods/presentation/providers/meal_repository_providers.dart';
import 'package:riverpod/riverpod.dart';

final ScanResultProvider =
    FutureProvider.family<List<FoodScanModel>, String>((ref, name) async {
  final mealRepository = ref.read(mealRepositoryProvider);
  return mealRepository.getFoodsFromScan(name);
});

final ScanResultDetailProvider =
    FutureProvider.family<FoodScanDetailModel, String>((ref, upcId) async {
  final mealRepository = ref.read(mealRepositoryProvider);
  return mealRepository.getFoodScanDetail(upcId);
});
