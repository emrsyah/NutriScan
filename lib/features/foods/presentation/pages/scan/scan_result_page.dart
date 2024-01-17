import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_result_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_result_detail.dart';
import 'package:nutriscan/theme.dart';

class ScanResultPage extends ConsumerWidget {
  final Uint8List imageBytes;
  final String name;

  const ScanResultPage({
    super.key,
    required this.imageBytes,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsyncValue = ref.watch(ScanResultProvider("Bakso"));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Hasil Scan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          shape: Border(
              bottom: BorderSide(
            color: graySecond,
            width: 0.5,
          )),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [softDrop],
                    color: Colors.white,
                    border: softBorder,
                  ),
                  child: Image.memory(
                    imageBytes,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover, // Set the fit property
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                (name != "" ? name : "Nama Makanan"),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              )),
              const SizedBox(
                height: 12,
              ),
              Divider(
                color: graySecond,
                thickness: 0.6,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Top Result",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: gray, fontSize: 15),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 12,
              ),
              resultAsyncValue.when(
                data: (data) {
                  if (data.length > 1) {
                    // Display the list of items after the top result
// Assuming data[index] is an instance of FoodScanModel
// Adjust the properties based on your actual model structure

                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length, // Exclude the top result
                        itemBuilder: (context, index) {
                          final foodItem = data[index]; // Skip the top result

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanResulDetailPage(
                                          id: data[index].id)));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0), // Adjust as needed
                              padding: const EdgeInsets.all(16.0), // Adjust as needed
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [softDrop],
                                border: softBorder,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80.0, // Fixed width for the image
                                    height: 80.0, // Fixed height for the image
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        foodItem.image,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          16.0), // Add space between image and text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          foodItem.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        // Add more Text widgets or other UI elements as needed
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No additional results available.");
                  }
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
