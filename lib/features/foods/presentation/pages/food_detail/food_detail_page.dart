import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_controller.dart';
import 'package:nutriscan/theme.dart';
import 'package:nutriscan/utils/food_utils.dart';

class FoodDetailsPage extends ConsumerStatefulWidget {
  final int foodId;

  // const FoodDetailsPage({super.key});
  const FoodDetailsPage({super.key, required this.foodId});

  @override
  ConsumerState<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends ConsumerState<FoodDetailsPage> {
  @override
  void initState() {
    super.initState();
    // print(widget.foodId);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left_rounded,
                size: 32, color: Colors.black54)),
        title: const Text("Detail Makanan",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
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
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          decoration: BoxDecoration(
                              color: getBgColor(meal!.ingredientAisles!,
                                  ref.read(authControllerProvider).allergies!),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            getStatusText(meal!.ingredientAisles!,
                                ref.read(authControllerProvider).allergies!),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: getTextColor(
                                    meal!.ingredientAisles!,
                                    ref
                                        .read(authControllerProvider)
                                        .allergies!)),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                                border: softBorder,
                                boxShadow: [softDrop],
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
                        const SizedBox(
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
                                    labelStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    labelColor: Colors.white,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green,
                                        border: Border.all(width: 0)),
                                    tabs: const [
                                      Tab(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Bahan"),
                                          )),
                                      Tab(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Instruksi"),
                                          )),
                                    ]),
                                const SizedBox(height: 24),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: TabBarView(

                                      children: [
                                      Column(
                                        children: List.generate(
                                            meal?.extendedIngredients?.length ??
                                                0, (index) {
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          getStatusIcon(
                                                            [
                                                              meal
                                                                      ?.extendedIngredients?[
                                                                          index]
                                                                      .aisle ??
                                                                  ""
                                                            ],
                                                            ref
                                                                .read(
                                                                    authControllerProvider)
                                                                .allergies!,
                                                          ),
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            meal
                                                                    ?.extendedIngredients?[
                                                                        index]
                                                                    .name ??
                                                                "-",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(meal
                                                              ?.extendedIngredients?[
                                                                  index]
                                                              .amount
                                                              ?.toInt()
                                                              .toString() ??
                                                          "-"),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(meal
                                                              ?.extendedIngredients?[
                                                                  index]
                                                              .unit ??
                                                          "-"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              )
                                            ],
                                          );
                                        }),
                                      ),
                                      meal.recipeSteps.isNotEmpty
                                          ? Column(
                                              children: List.generate(
                                                  meal?.recipeSteps?.length ??
                                                      0, (index) {
                                                return Column(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        border: softBorder,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        color: Colors.white,
                                                        // border: Border.all(width: 0.6, color: graySecond),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.14),
                                                            spreadRadius: 0,
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(0, 1),
                                                          )
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Langkah ${index + 1}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            meal
                                                                .recipeSteps[
                                                                    index]
                                                                .step,
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        170,
                                                                        0,
                                                                        0,
                                                                        0)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    )
                                                  ],
                                                );
                                              }),
                                            )
                                          : const Text(
                                              "Belum ada instruksi",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45),
                                            )

                                      // Center(child: Text("Tidak ada instruksi", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),))
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        Text(
          desc,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black45,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

String getStatusText(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return 'Kamu Alergi Makanan Ini';
  } else if (containsWarnAllergens(labels, allergies)) {
    return 'Mengandung Bahan yang Kamu Waspadai';
  } else {
    return 'Makanan Aman Kamu Konsumsi';
  }
}

Color getBgColor(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return HexColor("#F4CDC4");
  } else if (containsWarnAllergens(labels, allergies)) {
    return HexColor("#F8FCE8");
  } else {
    return secondary;
  }
}

Color getTextColor(List<String> labels, Map<String, dynamic> allergies) {
  if (containsNoAllergens(labels, allergies)) {
    return HexColor("#E81D23");
  } else if (containsWarnAllergens(labels, allergies)) {
    return HexColor("#E6C620");
  } else {
    return primary;
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
