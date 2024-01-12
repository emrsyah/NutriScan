//import meal_model.dart
import 'meal_model.dart';
class MealPlan {
  //MealPlan class has a list of meals and nutritional info about the meal plan
  final List<Meal> meals;
  final double calories, carbs, fat, protein;
MealPlan({
    required this.meals, required this.calories, required this.carbs, required this.fat, required this.protein
});
/*
The factory constructor iterates over the list of meals and our decoded mealplan
data and creates a list of meals.
Then, we return MealPlan object with all the information 
*/
factory MealPlan.fromMap(Map<String, dynamic> map) {
  print("flag 4444");
  print(map);
  List<Meal> meals = [];
  
  if (map.containsKey('meals') && map['meals'] is List) {
    meals = map['meals'].map((mealMap) => Meal.fromMap(mealMap)).toList();
  }

  // Handle the case where 'nutrients' might be missing or null
  Map<String, dynamic> nutrientsMap = map['nutrients'] ?? {};

  //MealPlan object with information we want
  return MealPlan(
    meals: meals,
    calories: nutrientsMap['calories'] ?? 0.0,
    carbs: nutrientsMap['carbohydrates'] ?? 0.0,
    fat: nutrientsMap['fat'] ?? 0.0,
    protein: nutrientsMap['protein'] ?? 0.0,
  );
}
}