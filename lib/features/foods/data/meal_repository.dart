// meal_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutriscan/features/foods/domain/food_scan.dart';
import 'package:nutriscan/features/foods/domain/food_scan_detail.dart';
import 'package:nutriscan/features/foods/domain/meal_detail.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';

class MealRepository {
  final String _baseURL = "api.spoonacular.com";
  final String _apiKey = "fa423bb3799b47f899e35707491a9a32";

  // * UNTUK JURI HACKFEST SUDAH KAMI SEDIAKAN 3 API_KEY, 2 Sebagai Cadangan
  // final String _apiKey = "46d7ce88f3064ad6aac01e5164b7fcbc";
  // final String _apiKey = "f8d6eeac11f24328b1b155731a5cdd29";

  Future<List<Meal>> getFoods(String excludeTags) async {
    Map<String, String> parameters = {
      'timeFrame': 'day',
      'apiKey': _apiKey,
      'number': '5',
      // 'include-tags' : "nut",
      'exclude-tags' : excludeTags
    };



    Uri uri = Uri.https(_baseURL, '/recipes/random', parameters);
    var response = await http.get(uri);
    var jsonData = jsonDecode(response.body);
    if(response.statusCode == 402 && response.body.contains("daily points limit")){
      throw "Api Key Mencapai Limit, Kami Menyediakan 2 Api Key Cadangan Sebagai Tambahan, Tolong Cek File meal_repository.dart";
      // print(jsonDecode(response.body));
    }

    List<Meal> local_recipes = [];
    print('-----------------------------------------------------------');
    print(jsonData["recipes"][0]);
    print(jsonData["recipes"].length);
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

  Future<List<FoodScanModel>> getFoodsFromScan(String name) async {
    Map<String, String> parameters = {
      'apiKey': _apiKey,
      'query': name,
    };
    Uri uri = Uri.https(_baseURL, '/food/products/search', parameters);
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> productsJson = jsonData['products'];
      List<FoodScanModel> products = productsJson
          .map((product) => FoodScanModel.fromMap(product))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load food details');
    }
  }

  Future<FoodScanDetailModel> getFoodScanDetail(int id) async {
    // * GAK SEMUA MAKANAN BISA PAKE UPC LANGSUNG, NANTI BUAT AJA LAGI YANG FUNCTION KHUSUS UPC KALO BARCODE
    Map<String, String> parameters = {
      'apiKey': _apiKey,
    };
    // print(formattedUpc);
    Uri uri = Uri.https(_baseURL, '/food/products/$id', parameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      FoodScanDetailModel transformed = FoodScanDetailModel.fromMap(jsonData);
      return transformed;
    } else {
      if ((jsonDecode(response.body)["message"] as String).contains("does not exist.")){
        throw ("Makanan dengan Id $id tak ditemukan");
      }
      throw Exception('Failed to load food details');
    }
  }
}
