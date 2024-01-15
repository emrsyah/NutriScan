import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/widget/food_card.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/widget/home_topbar.dart';

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

var logger = Logger();

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    getAllFoods();
  }

  Future<void> getAllFoods() async {
    await ref.read(mealControllerProvider.notifier).getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              HomeTopBar(),
              TextButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut(context);
                  },
                  child: Text("Lgout")),
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
              Expanded(child: Consumer(
                builder: (context, ref, _) {
                  final meals = ref.watch(mealControllerProvider);
                  if (meals.isEmpty) {
                    return Center(
                      child: Text('No recipes found.'),
                    );
                  } else {
                    // print(meals[0].mealInfo.toString());
                    // final log = Logger();
                    // log.d(meals[0].mealInfo.toString());
                    return ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        // Text(meals.length.toString());
                        if (index >= 0 && index < meals.length) {
                          return FoodCard(recipes: meals, index: index);
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
              )),
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
              icon: GestureDetector(
                onTap: () => {},
                child: Container(
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
