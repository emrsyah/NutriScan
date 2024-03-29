import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final resultAsyncValue = ref.watch(FutureHomeFoodController(ref.read(authControllerProvider).allergies!));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              HomeTopBar(name: ref.read(authControllerProvider).name),
              TextField(
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
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () =>
                    ref.refresh(FutureHomeFoodController(ref.read(authControllerProvider).allergies!).future),
                child: resultAsyncValue.when(
                  data: (data) {
                    final meals = data;
                    if (meals.isEmpty) {
                      return const Center(
                        child: Text('No recipes found.'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          return FoodCard(
                            recipes: meals,
                            index: index,
                            userAllergies:
                                ref.read(authControllerProvider).allergies!,
                          );
                        },
                      );
                    }
                  },
                  error: (error, stack) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              'Terjadi Kesalahan: $error',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: gray),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(idx: 0),
    );
  }
}
