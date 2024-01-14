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

    bool isVegan = map['vegan'] as bool? ?? false;
    bool isGlutenFree = map['glutenFree'] as bool? ?? false;
    bool isDairyFree = map['dairyFree'] as bool? ?? false;
    bool isSustainable = map['sustainable'] as bool? ?? false;

    // Creating MealInfo with appropriate labels
    MealInfo mealInfo = MealInfo(
      labels: [
        if (isVegan) 'Vegan',
        if (isGlutenFree) 'Gluten-Free',
        if (isDairyFree) 'Dairy-Free',
        if (isSustainable) 'Sustainable',
      ],
    );
    return Meal(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? 'Unknown Title',
      imgURL: map["image"] ?? "",
      readyInMinutes: map['readyInMinutes'] as int? ?? 0,
      mealInfo: mealInfo,
    );
  }
}
