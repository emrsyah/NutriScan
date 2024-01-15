import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/foods/domain/meal_model.dart';
import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_page.dart';
import 'package:nutriscan/features/foods/presentation/widget/nutri_chip.dart';
import 'package:nutriscan/theme.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    Key? key,
    required List<Meal> recipes,
    required int index,
    required Map<String, dynamic>
        userAllergies, // Added userAllergies parameter
  })  : _recipes = recipes,
        _userAllergies = userAllergies, // Assigned to the instance variable
        index = index,
        super(key: key);

  final List<Meal> _recipes;
  final int index;
  final Map<String, dynamic> _userAllergies;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FoodDetailsPage(foodId: _recipes[index].id)));
      },
      child: Card(
          color: Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 240.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _recipes[index].imgURL ??
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png?20210219185637",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 12.0,
                      top: 12.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            100.0), // Adjust the radius as needed
                        child: Container(
                          color: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                _recipes[index].readyInMinutes.toString() +
                                    " mins",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
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
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _recipes[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          getStatusIcon(
                            _recipes[index].ingredientAisles,
                            _userAllergies,
                          ),
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: getStatusText(
                                  _recipes[index].ingredientAisles,
                                  _userAllergies,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: getStatusColor(
                                      _recipes[index].ingredientAisles,
                                      _userAllergies),
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: ' kamu konsumsi',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: gray,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: List.generate(
                        _recipes[index].mealInfo.labels.length,
                        (idx) {
                          return Row(
                            children: [
                              NutriChip(
                                  label: _recipes[index].mealInfo.labels[idx]),
                              SizedBox(width: 6.0), // Add space between items
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

String getStatusText(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return 'Peringatan Jangan';
  } else if (containsWarnAllergens(labels, allergies)) {
    return 'Waspada';
  } else {
    return 'Aman';
  }
}

String getStatusIcon(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return 'assets/image/x-icon.png';
  } else if (containsWarnAllergens(labels, allergies)) {
    return 'assets/image/warn2-icon.png';
  } else {
    return 'assets/image/check-icon.png';
  }
}

Color getStatusColor(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return Colors.red;
  } else if (containsWarnAllergens(labels, allergies)) {
    return HexColor("#E3AA00");
  } else {
    return primary;
  }
}

bool containsNoAllergens(List<String> labels, Map<String, dynamic> allergies) {
  for (String label in labels) {
    print('Label = ' + label);
    if (allergies.containsKey(label) && allergies[label] == 'NO') {
      return true;
    }
  }
  return false;
}

bool containsWarnAllergens(
    List<String> labels, Map<String, dynamic> allergies) {
  for (String label in labels) {
    if (allergies.containsKey(label) && allergies[label] == 'WARN') {
      return true;
    }
  }
  return false;
}
