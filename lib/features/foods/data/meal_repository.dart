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
    print(jsonData["recipes"][0]);
    for (var eachFood in jsonData["recipes"]) {
      Meal meal = Meal.fromMap(eachFood);
      local_recipes.add(meal);
    }

    return local_recipes;
  }

  Future<MealDetail> getFoodDetails(int foodId) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
      'includeNutrition' : 'true',
    };

    Uri uri = Uri.https(_baseURL, '/recipes/$foodId/information', parameters);
    var response = await http.get(uri);
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // print(jsonData);
      // print("flaggingggggggggggggggggggggg1");
      // print("detail meal 1");
      final log = Logger();
      // log.d(jsonDecode(response.body)[""]);
      // print(jsonData);
      // log.d(jsonData);
      log.d("===========================================================");

      return MealDetail.fromJson(jsonData);
    } else {
      throw Exception('Failed to load food details');
    }

  }

}
