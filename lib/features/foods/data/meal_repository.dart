// meal_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
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

    for (var eachFood in jsonData["recipes"]) {
      Meal meal = Meal.fromMap(eachFood);
      local_recipes.add(meal);
    }

    return local_recipes;
  }
}
