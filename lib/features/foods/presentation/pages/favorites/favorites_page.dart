import 'package:flutter/material.dart';
import 'package:nutriscan/features/foods/presentation/pages/common_widget/BottomNavigation.dart';
import 'package:nutriscan/theme.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "List Favorit Kamu ♥️",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        shape: Border(
          bottom: BorderSide(
            color: graySecond,
            width: 0.5,
          ),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(20), child: Column(
        children: [Center(child: Text("Sorry Favorite is Under Building"),)],
      ),),
      bottomNavigationBar: BottomNavigation(idx: 1),
    ));
  }
}
