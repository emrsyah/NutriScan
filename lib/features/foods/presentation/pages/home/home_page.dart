import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nutriscan/model/meal_info.dart';
import 'package:nutriscan/model/meal_model.dart';
import 'package:nutriscan/model/meal_plan_model.dart';
import 'package:nutriscan/model/recipe_model.dart';

import 'package:http/http.dart' as http;
import 'package:nutriscan/core/services/recipe_service.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/widget/home_topbar.dart';

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

var logger = Logger();

final String _baseURL = "api.spoonacular.com";
final String API_KEY = "46d7ce88f3064ad6aac01e5164b7fcbc";

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _diets = [
    //List of diets that lets spoonacular filter
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30',
  ];
  double _targetCalories = 2250;
  String _diet = 'None';

  List<Meal> _recipes = [];

  Future _getFoods() async {
    Map<String, String> parameters = {
      'timeFrame': 'day', //to get 3 meals
      // 'targetCalories': targetCalories.toString(),
      // 'diet': diet,
      'apiKey': API_KEY,
      'number': '5'
    };
    Uri uri = Uri.https(_baseURL, '/recipes/random', parameters);
    var response = await http.get(uri);
    var jsonData = jsonDecode(response.body);
    // logger.d(jsonData);
    List<Meal> local_recipes = [];
    for (var eachFood in jsonData["recipes"]) {
      int minuteReady = eachFood["readyInMinutes"];
      List<String> localLabel = [];
      if (eachFood["vegetarian"]) {
        localLabel.add("Vegetarian");
      }
      if (eachFood["glutenFree"]) {
        localLabel.add("Gluten Free");
      }
      if (eachFood["cheap"]) {
        localLabel.add("Cheap");
      }
      if (eachFood["sustainable"]) {
        localLabel.add("Sustainable");
      }
      if (eachFood["dairyFree"]) {
        localLabel.add("Dairy Free");
      }
      final food = Meal(
          id: eachFood["id"],
          title: eachFood["title"],
          imgURL: eachFood["image"] ??
              'https://spoonacular.com/recipeImages/' + eachFood['image'],
          readyInMinutes: minuteReady,
          mealInfo: MealInfo(labels: localLabel));
      local_recipes.add(food);
    }

    _recipes = local_recipes;
    logger.d("Flaggingggggggggggggggggggggg");
    print(_recipes.length);
    logger.d(_recipes);
    logger.d("Flaggingggggggggggggggggggggg");
    // logger.d(response.body);
  }

  // void _getRecipes() async {
  //   try {
  //     logger.d("Flag 111111");
  //     logger.d(_targetCalories);
  //     logger.d(_diet);
  //     logger.d("Flag 222222");
  //     MealPlan mealPlan = await ApiService.instance
  //         .generateMealPlan(targetCalories: 2250, diet: "None");

  //     // Update the _recipes list with the fetched recipes
  //     setState(() {
  //       _recipes = mealPlan.meals;
  //     });

  //     // print(mealPlan);
  //     // loggerNoStack.t(mealPlan);
  //     print("haloooooooooooooooooooooooooooooo1111");
  //     logger.d("halooooooooooooooooooooooooooooooo");
  //     logger.d(mealPlan);
  //     logger.d("halooooooooooooooooooooooooooooooo");
  //   } catch (error) {
  //     // Handle errors
  //     print('Error fetching recipes: $error');
  //     logger.e('Error fetching recipes: $error');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _getFoods();
    // _getRecipes();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              HomeTopBar(),
              Container(
                child: TextField(
                  // onTap: () => {print(_recipes)},
                  decoration: InputDecoration(
                    labelText: 'Cari Makanan & Minuman',
                    filled: true,
                    fillColor: Color.fromARGB(255, 245, 245, 245),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Adjust the border radius as needed
                      borderSide: BorderSide.none, // Remove the border
                    ),
                    contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                  ),
                ),
              ),
              // Text(_recipes.length.toString()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 8),
                    // Wrap with Container
                    width: double.infinity, // Take up the full width
                    child: Text(
                      "Rekomendasi Buat Kamu",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                    future: _getFoods(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_recipes == null || _recipes.isEmpty) {
                          return Center(
                            child: Text('No recipes found.'),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: _recipes.length,
                              itemBuilder: (context, index) {
                                if (index >= 0 && index < _recipes.length) {
                                  return Card(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 240.0,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.network(
                                                  _recipes[index].imgURL,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  right: 12.0,
                                                  top: 12.0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0), // Adjust the radius as needed
                                                    child: Container(
                                                      color: Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 6,
                                                              horizontal: 12),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(Icons
                                                              .timer_outlined),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            _recipes[index]
                                                                    .readyInMinutes
                                                                    .toString() +
                                                                " mins",
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _recipes[index].title,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(height: 6,),
                                                Row(
                                                  children: List.generate(
                                                    _recipes[index]
                                                        .mealInfo
                                                        .labels
                                                        .length,
                                                    (idx) {
                                                      return Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.green
                                                              ),
                                                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                              child: Text(_recipes[index]
                                                                  .mealInfo
                                                                  .labels[idx],
                                                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white,fontSize: 13),
                                                                  ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  6.0), // Add space between items
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ));
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.14),
              spreadRadius: 4,
              blurRadius: 710,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0, // Set the initial selected index
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
          backgroundColor:
              Colors.white, // Adjust the background color as needed
          iconSize: 28,
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,

          // Handle navigation item taps
          onTap: (index) {
            // Add your navigation logic here
          },

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 72.0,
                height: 72.0,
                decoration: BoxDecoration(
                  color: Color(0xFF25A35F), // Background color #25A35F
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.integration_instructions),
              label: 'Donasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class Group3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 383,
          height: 237,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 383,
                  height: 237,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x28000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 383,
                  height: 164,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/383x164"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 172,
                child: Text(
                  'Tuna Garlic with Side of Vegetables',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 299,
                top: 12,
                child: Container(
                  width: 75,
                  height: 26,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.only(
                          top: 0.67,
                          left: 2,
                          right: 2,
                          bottom: 1.33,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '15 min',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 202,
                child: Container(
                  width: 192,
                  height: 21,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: ShapeDecoration(
                                color: Color(0xFF25A35F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 12,
                              height: 12,
                              padding: const EdgeInsets.only(
                                top: 2.81,
                                left: 1.31,
                                right: 0.94,
                                bottom: 2.06,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Aman ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: 'Kamu Konsumsi',
                              style: TextStyle(
                                color: Color(0xFF393939),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 335,
                top: 189,
                child: Container(
                  width: 36,
                  height: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.30, color: Color(0xFFCCD0D6)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.only(
                          top: 3,
                          left: 2,
                          right: 2,
                          bottom: 3.35,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
