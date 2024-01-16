import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_result_controller.dart';
import 'package:nutriscan/features/foods/presentation/widget/nutri_chip.dart';
import 'package:nutriscan/theme.dart';

class ScanResulDetailPage extends ConsumerWidget {
  const ScanResulDetailPage({super.key, required this.upcId});

  final String upcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsyncValue = ref.watch(ScanResultDetailProvider(upcId));
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
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
                      SizedBox(
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
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            softDrop
                          ],
                          border: softBorder,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NutritionItem(label: 'Carbs', content: data.carbs),
                            NutritionItem(label: 'Protein', content: data.protein),
                            NutritionItem(label: 'Fat', content: data.fat),
                            NutritionItem(
                                label: 'Calories', content: data.calories != null ? '${data.calories} kcal' : '-'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Divider(color: graySecond, thickness: 0.5),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        "Kandungan:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: List.generate(
                            data.ingredients.split(", ").length, (index) {
                          List<String> ings = data.ingredients.split(", ");
                          return NutriChip(label: ings[index]);
                        }),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Tagar:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: List.generate(data.badges.length, (index) {
                          return NutriChip(label: data.badges[index]);
                        }),
                      )
                    ],
                  ),
                ),
              );
            },
            error: (error, stack) {
              return Center(child: Text('Error: $error'));
            },
          )),
    );
  }
}

class NutritionItem extends StatelessWidget {
  final String label;
  final String content;

  const NutritionItem({Key? key, required this.label, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          content,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: gray),
        ),
      ],
    );
  }
}
