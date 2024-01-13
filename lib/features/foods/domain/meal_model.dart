import 'package:nutriscan/features/foods/domain/meal_info.dart';

class Meal {
  final int id, readyInMinutes;
  final String title, imgURL;
  final MealInfo mealInfo;

  Meal({
    required this.id,
    required this.title,
    required this.imgURL,
    required this.readyInMinutes,
    required this.mealInfo,
  });

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? 'Unknown Title',
      imgURL: map["image"] ?? "",
      readyInMinutes: map['readyInMinutes'] as int? ?? 0,
      mealInfo:
          MealInfo.fromMap(map['mealInfo'] as Map<String, dynamic>? ?? {}),
    );
  }
}
