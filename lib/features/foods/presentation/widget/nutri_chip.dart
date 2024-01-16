import 'package:flutter/material.dart';
import 'package:nutriscan/theme.dart';

class NutriChip extends StatelessWidget {
  const NutriChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: BoxDecoration(
          color: primary
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(label,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white,fontSize: 13),
            ),
      ),
    );
  }
}
