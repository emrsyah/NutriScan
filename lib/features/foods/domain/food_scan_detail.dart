// ignore_for_file: public_member_api_docs, sort_constructors_first
class FoodScanDetailModel {
  final int id;
  final String title;
  final String image;
  final List<String> badges;
  final List<String> importantBadges;
  final String ingredients;
  final String carbs;
  final String protein;
  final String fat;
  final int? calories;

  FoodScanDetailModel({
    required this.id,
    required this.title,
    required this.image,
    required this.badges,
    required this.importantBadges,
    required this.ingredients,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.calories,
  });

  FoodScanDetailModel copyWith({
    int? id,
    String? title,
    String? image,
    List<String>? badges,
    List<String>? importantBadges,
    String? ingredients,
    String? carbs,
    String? protein,
    String? fat,
    int? calories,
  }) {
    return FoodScanDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      badges: badges ?? this.badges,
      importantBadges: importantBadges ?? this.importantBadges,
      ingredients: ingredients ?? this.ingredients,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      calories: calories ?? this.calories,
    );
  }

  factory FoodScanDetailModel.fromMap(Map<String, dynamic> map) {
    String ings = map["ingredientCount"] > 0 ? map["ingredientList"] : [];

    return FoodScanDetailModel(
        id: map["id"],
        title: map["title"],
        image: map["image"],
        badges: map["badges"],
        importantBadges: map["importantBadges"],
        ingredients: ings,
        carbs:
            map["nutrition"]["carbs"] ?? "-",
        protein: map["nutrition"]["protein"] ?? "-",
        fat: map["nutrition"]["fat"] ?? "-",
        calories: map["nutrition"]["calories"]);
  }
}
