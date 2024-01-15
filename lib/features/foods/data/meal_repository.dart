// meal_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nutriscan/features/foods/domain/meal_detail.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';

class MealRepository {
  final String _baseURL = "api.spoonacular.com";
  final String _apiKey = "46d7ce88f3064ad6aac01e5164b7fcbc";

  Future<List<Meal>> getFoods() async {
    Map<String, String> parameters = {
      'timeFrame': 'day',
      'apiKey': _apiKey,
      'number': '5',
    };

    Uri uri = Uri.https(_baseURL, '/recipes/random', parameters);
    var response = await http.get(uri);
    var jsonData = jsonDecode(response.body);

    List<Meal> local_recipes = [];
    print('-----------------------------------------------------------');
    print(jsonData["recipes"][0]);
    print('-----------------------------------------------------------');
    for (var eachFood in jsonData["recipes"]) {
      Meal meal = Meal.fromMap(eachFood);
      local_recipes.add(meal);
    }

    return local_recipes;
  }

  Future<List<dynamic>> getRecipeInstructions(int foodId) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
      'stepBreakdown': 'true',
    };

    Uri uri = Uri.https(
        _baseURL, '/recipes/$foodId/analyzedInstructions', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> stepsData = jsonData[0]['steps'] ?? [];
      return stepsData;
    } else {
      throw Exception('Failed to load recipe instructions');
    }
  }

  Future<MealDetail> getFoodDetails(int foodId) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
      'includeNutrition': 'true',
    };

    Uri uri = Uri.https(_baseURL, '/recipes/$foodId/information', parameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> recipeSteps = await getRecipeInstructions(foodId);
      return MealDetail.fromJson({...jsonData, "steps": recipeSteps});
    } else {
      throw Exception('Failed to load food details');
    }
  }
}
