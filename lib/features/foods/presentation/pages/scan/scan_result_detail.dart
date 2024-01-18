import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_result_controller.dart';
import 'package:nutriscan/features/foods/presentation/widget/nutri_chip.dart';
import 'package:nutriscan/theme.dart';

class ScanResulDetailPage extends ConsumerWidget {
  const ScanResulDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsyncValue = ref.watch(ScanResultDetailProvider(id));
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Detail Produk',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            centerTitle: true,
            shape: Border(
                bottom: BorderSide(
              color: graySecond,
              width: 0.5,
            )),
          ),
          body: resultAsyncValue.when(
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            data: (data) {
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [softDrop], border: softBorder),
                            child: Image.network(
                              data.image,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [softDrop],
                          border: softBorder,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NutritionItem(label: 'Carbs', content: data.carbs),
                            NutritionItem(
                                label: 'Protein', content: data.protein),
                            NutritionItem(label: 'Fat', content: data.fat.contains(".") ? data.fat.split(".")[0] : data.fat),
                            NutritionItem(
                                label: 'Calories',
                                content: data.calories != null
                                    ? '${data.calories!.toStringAsFixed(0)} kcal'
                                    : '-'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Divider(color: graySecond, thickness: 0.5),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        "Kandungan:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 8.0,
                          runSpacing: 10.0,
                          children: data.ingredients != ""
                              ? List.generate(
                                  data.ingredients.split(", ").length, (index) {
                                  List<String> ings =
                                      data.ingredients.split(", ");
                                  return NutriChip(label: ings[index]);
                                })
                              : [
                                  Text(
                                    "Tidak ada data kandungan",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: gray),
                                  )
                                ]),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        "Tagar:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: data.badges.isNotEmpty
                            ? List.generate(data.badges.length, (index) {
                                return NutriChip(label: data.badges[index]);
                              })
                            : [
                                Text(
                                  "Tidak ada tagar",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: gray),
                                )
                              ],
                      )
                    ],
                  ),
                ),
              );
            },
            error: (error, stack) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Terjadi Kesalahan: $error', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: gray),),
              ), );
            },
          )),
    );
  }
}

class NutritionItem extends StatelessWidget {
  final String label;
  final String content;

  const NutritionItem({super.key, required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          content,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style:
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: gray),
        ),
      ],
    );
  }
}
