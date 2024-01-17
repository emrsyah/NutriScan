import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/common_widget/BottomNavigation.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/widget/food_card.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/widget/home_topbar.dart';
import 'package:nutriscan/theme.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              HomeTopBar(name: ref.read(authControllerProvider).name),
              TextButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut(context);
                  },
                  child: const Text("Lgout")),
              TextField(
                // onTap: () => {print(_recipes)},
                decoration: InputDecoration(
                  labelText: 'Cari Makanan & Minuman',
                  hintStyle: TextStyle(color: graySecond),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 245, 245, 245),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Adjust the border radius as needed
                    borderSide: BorderSide.none, // Remove the border
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                ),
              ),
              // Text(_recipes.length.toString()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    // Wrap with Container
                    width: double.infinity, // Take up the full width
                    child: const Text(
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
                    return const Center(
                      child: Text('No recipes found.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        if (index >= 0 && index < meals.length) {
                          return FoodCard(recipes: meals, index: index, userAllergies: ref.read(authControllerProvider).allergies!,);
                        } else {
                          return const SizedBox.shrink();
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
      bottomNavigationBar: const BottomNavigation(idx: 0),
    );
  }
}
