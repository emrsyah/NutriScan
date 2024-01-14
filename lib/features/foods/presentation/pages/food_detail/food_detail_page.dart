import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_controller.dart';
import 'package:nutriscan/features/foods/presentation/widget/nutri_chip.dart';

class FoodDetailsPage extends ConsumerStatefulWidget {
  final int foodId;

  // const FoodDetailsPage({super.key});
  FoodDetailsPage({required this.foodId});

  @override
  ConsumerState<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends ConsumerState<FoodDetailsPage> {
  @override
  void initState() {
    super.initState();
    print(widget.foodId);
    getFoodDetails();
  }

  Future<void> getFoodDetails() async {
    // await ref.read(mealControllerProvider.notifier);
    await ref
        .read(foodDetailControllerProvider.notifier)
        .getFoodDetails(widget.foodId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left_rounded,
                size: 32, color: Colors.black54)),
        title: Text("Detail Makanan",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Consumer(
                builder: (context, ref, _) {
                  final meal = ref.watch(foodDetailControllerProvider);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(meal?.image ??
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png?20210219185637"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            meal?.title ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                meal?.mealInfo.labels.length as int? ?? 0,
                                (index) {
                              return Row(
                                children: [
                                  NutriChip(
                                      label:
                                          meal?.mealInfo.labels[index] ?? ""),
                                  SizedBox(
                                    width: 6,
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.black12, width: 0.7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.14),
                                    spreadRadius: 4,
                                    blurRadius: 710,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FactInfo(
                                      info: meal?.readyInMinutes.toString() ??
                                          "-",
                                      desc: "min"),
                                  FactInfo(
                                      info: meal?.extendedIngredients?.length
                                              .toString() ??
                                          "-",
                                      desc: "Bahan"),
                                  FactInfo(
                                      info: meal?.calories.toString() ?? "-",
                                      desc: "Kcal"),
                                  FactInfo(
                                      info: meal?.servings.toString() ?? "-",
                                      desc: "Sajian"),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 32,
                        ),
                        DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                    labelPadding: EdgeInsets.zero,
                                    indicatorColor: Colors.transparent,
                                    dividerColor: Colors.transparent,
                                    unselectedLabelColor: Colors.black54,
                                    labelStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    labelColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green,
                                        border: Border.all(width: 0)),
                                    tabs: [
                                      Tab(
                                          child: Container(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text("Bahan"),
                                        ),
                                      )),
                                      Tab(
                                          child: Container(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text("Instruksi"),
                                        ),
                                      )),
                                    ]),
                                SizedBox(height: 24),
                                Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: TabBarView(children: [
                                      Column(
                                        children: List.generate(
                                            meal?.extendedIngredients?.length ??
                                                0, (index) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    meal
                                                            ?.extendedIngredients?[
                                                                index]
                                                            .name ??
                                                        "-",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        color: Colors.black87),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(meal
                                                                  ?.extendedIngredients?[
                                                                      index]
                                                                  .amount
                                                                  ?.toInt()
                                                                  .toString() ??
                                                              "-"),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          Text(meal
                                                                  ?.extendedIngredients?[
                                                                      index]
                                                                  .unit ??
                                                              "-")
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12,)
                                            ],
                                          );
                                        }),
                                      ),
                                      Center(child: Text("Tidak ada instruksi", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),))
                                    ]))
                              ],
                            ))
                      ],
                    ),
                  );
                },
              ))),
    );
  }
}

class FactInfo extends StatelessWidget {
  const FactInfo({Key? key, required this.info, required this.desc})
      : super(key: key);

  final String info;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          info,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        Text(
          desc,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black45,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}