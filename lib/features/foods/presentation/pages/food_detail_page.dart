import 'package:flutter/material.dart';

class FoodDetailsPage extends StatelessWidget {
  final int foodId;

  // const FoodDetailsPage({super.key});
  FoodDetailsPage({required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            Icon(Icons.chevron_left_rounded, size: 32, color: Colors.black54),
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
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.network("src"),
                  )
                ],
              ))),
    );
  }
}
