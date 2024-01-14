// meal_model.dart

import 'package:nutriscan/features/foods/domain/meal_info.dart';

class MealDetail {
  final int? id;
  final String? title;
  final String? image;
  final int? readyInMinutes;
  final double? healthScore;
  final double? pricePerServing;
  final List<ExtendedIngredient>? extendedIngredients;
  final String? summary;
  final int? servings;
  final String? aisle;
  final double? calories; // Add this property

  // Additional Details
  // final List<String>? ingredients;
  final List<String>? steps;
  final String? description;
  final MealInfo mealInfo;
  final List<Nutrient>? nutrients; // Add this property

  // final double? calories;
  // final int? servingSize;

  MealDetail(
      {required this.id,
      required this.title,
      required this.image,
      required this.readyInMinutes,
      required this.healthScore,
      required this.pricePerServing,
      required this.extendedIngredients,
      required this.summary,
      required this.nutrients,
      // required this.ingredients,
      required this.steps,
      required this.description,
      required this.mealInfo,
      required this.servings,
      required this.aisle,
      required this.calories
      // required this.calories,
      // required this.servingSize,
      });

  factory MealDetail.fromMap(Map<String, dynamic>? map) {
    bool isVegan = map?['vegan'] as bool? ?? false;
    bool isGlutenFree = map?['glutenFree'] as bool? ?? false;
    bool isDairyFree = map?['dairyFree'] as bool? ?? false;
    bool isSustainable = map?['sustainable'] as bool? ?? false;

    List<Nutrient>? nutrientsList = List<Nutrient>.from(
        map?['nutrition']['nutrients']?.map((x) => Nutrient.fromMap(x)));

    // Creating MealInfo with appropriate labels
    MealInfo mealInfo = MealInfo(
      labels: [
        if (isVegan) 'Vegan',
        if (isGlutenFree) 'Gluten-Free',
        if (isDairyFree) 'Dairy-Free',
        if (isSustainable) 'Sustainable',
      ],
    );

    double calories = map?['nutrition']['nutrients']
        ?.firstWhere((nutrient) => nutrient['name'] == 'Calories')['amount']
        ?.toDouble();

    MealDetail meal = MealDetail(
      id: map?['id'],
      title: map?['title'],
      image: map?['image'],
      readyInMinutes: map?['readyInMinutes'],
      healthScore: map?['healthScore']?.toDouble(),
      pricePerServing: map?['pricePerServing']?.toDouble(),
      extendedIngredients: List<ExtendedIngredient>.from(
          map?['extendedIngredients']
              ?.map((x) => ExtendedIngredient.fromMap(x))),
      summary: map?['summary'],
      servings: map?["servings"],
      // ingredients: List<String>?.from(
      //     map?['extendedIngredients']?.map((x) => x?['original'])),
      steps: [""], // You need to extract the steps from the JSON
      description: '', // You need to extract the description from the JSON
      // calories: map?['calories'] != null ? map?['calories']?.toDouble() : null,
      // servingSize: map?['servingSize'] != null ? map?['servingSize'] : null,
      mealInfo: mealInfo,
      nutrients: nutrientsList,
      calories: calories,
      aisle: map?["aisle"],
    );
    // print(meal);
    return meal;
  }

  factory MealDetail.fromJson(Map<String, dynamic>? json) {
    bool isVegan = json?['vegan'] as bool? ?? false;
    bool isGlutenFree = json?['glutenFree'] as bool? ?? false;
    bool isDairyFree = json?['dairyFree'] as bool? ?? false;
    bool isSustainable = json?['sustainable'] as bool? ?? false;

    // Creating MealInfo with appropriate labels
    MealInfo mealInfo = MealInfo(
      labels: [
        if (isVegan) 'Vegan',
        if (isGlutenFree) 'Gluten-Free',
        if (isDairyFree) 'Dairy-Free',
        if (isSustainable) 'Sustainable',
      ],
    );

    double calories = json?['nutrition']['nutrients']
        ?.firstWhere((nutrient) => nutrient['name'] == 'Calories')['amount']
        ?.toDouble();

    List<Nutrient>? nutrientsList = List<Nutrient>.from(
        json?['nutrition']['nutrients']?.map((x) => Nutrient.fromMap(x)));

    return MealDetail(
      id: json?['id'],
      title: json?['title'],
      image: json?['image'],
      readyInMinutes: json?['readyInMinutes'],
      healthScore: json?['healthScore']?.toDouble(),
      pricePerServing: json?['pricePerServing']?.toDouble(),
      extendedIngredients: List<ExtendedIngredient>.from(
          json?['extendedIngredients']
              ?.map((x) => ExtendedIngredient.fromMap(x))),
      summary: json?['summary'],
      // ingredients: List<String>?.from(
      //     json?['extendedIngredients']?.map((x) => x?['original'])),
      steps: [""], // You need to extract the steps from the JSON
      description: '', // You need to extract the description from the JSON
      servings: json?["servings"],
      calories: calories,
      // calories: json?['calories'] != null ? json?['calories']?.toDouble() : null,
      // servingSize: json?['servingSize'] != null ? json?['servingSize'] : null,
      mealInfo: mealInfo,
      nutrients: nutrientsList,
      aisle: json?["aisle"],
    );
  }
}

class ExtendedIngredient {
  final String? aisle;
  final double? amount;
  final String? consitency;
  final int? id;
  final String? image;
  final Measures? measures;
  final List<String>? meta;
  final String? name;
  final String? original;
  final String? originalName;
  final String? unit;

  ExtendedIngredient({
    required this.aisle,
    required this.amount,
    required this.consitency,
    required this.id,
    required this.image,
    required this.measures,
    required this.meta,
    required this.name,
    required this.original,
    required this.originalName,
    required this.unit,
  });

  factory ExtendedIngredient.fromMap(Map<String, dynamic>? map) {
    return ExtendedIngredient(
      aisle: map?['aisle'],
      amount: map?['amount']?.toDouble(),
      consitency: map?['consitency'],
      id: map?['id'],
      image: map?['image'],
      measures: Measures.fromMap(map?['measures']),
      meta: List<String>.from(map?['meta']),
      name: map?['name'],
      original: map?['original'],
      originalName: map?['originalName'],
      unit: map?['unit'],
    );
  }
}

class Measures {
  final Metric? metric;
  final Metric? us;

  Measures({
    required this.metric,
    required this.us,
  });

  factory Measures.fromMap(Map<String, dynamic>? map) {
    return Measures(
      metric: Metric.fromMap(map?['metric']),
      us: Metric.fromMap(map?['us']),
    );
  }
}

class Metric {
  final double? amount;
  final String? unitLong;
  final String? unitShort;

  Metric({
    required this.amount,
    required this.unitLong,
    required this.unitShort,
  });

  factory Metric.fromMap(Map<String, dynamic>? map) {
    return Metric(
      amount: map?['amount']?.toDouble(),
      unitLong: map?['unitLong'],
      unitShort: map?['unitShort'],
    );
  }
}

class Nutrient {
  final String? name;
  final double? amount;
  final String? unit;
  final double? percentOfDailyNeeds;

  Nutrient({
    required this.name,
    required this.amount,
    required this.unit,
    required this.percentOfDailyNeeds,
  });

  factory Nutrient.fromMap(Map<String, dynamic>? map) {
    return Nutrient(
      name: map?['name'],
      amount: map?['amount']?.toDouble(),
      unit: map?['unit'],
      percentOfDailyNeeds: map?['percentOfDailyNeeds']?.toDouble(),
    );
  }
}
