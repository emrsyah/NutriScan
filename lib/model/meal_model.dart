import 'package:nutriscan/model/meal_info.dart';

class Meal {
  final int id, readyInMinutes;
  final String title, imgURL;
  final MealInfo mealInfo;

  Meal({required this.id, required this.title, required this.imgURL, required this.readyInMinutes, required this.mealInfo});

  factory Meal.fromMap(Map<String, dynamic> map) {
    // Ensure that 'id', 'title', and 'image' keys are present in the map
    if (map.containsKey('id') &&
        map.containsKey('title') &&
        map.containsKey('image')) {
      return Meal(
        id: map['id'] ?? 0,
        title: map['title'] ?? 'Unknown Title',
        imgURL: 'https://spoonacular.com/recipeImages/' + (map['image'] ?? ''),
        readyInMinutes: 0,
        mealInfo: MealInfo(labels: ["Vegetarian"])
      );
    } else {
      // Handle the case where essential keys are missing
      throw ArgumentError("Invalid map for Meal.fromMap");
    }
  }
}
