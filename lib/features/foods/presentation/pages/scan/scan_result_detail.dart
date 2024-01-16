import 'package:flutter/material.dart';

class ScanResulDetailPage extends StatelessWidget {
  const ScanResulDetailPage({super.key, required this.upcId});

  final String upcId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(upcId),
        ),
      ),
    );
  }
}
