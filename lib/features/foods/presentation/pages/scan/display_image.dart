import 'dart:typed_data';

import 'package:flutter/material.dart';

class DisplayImagePage extends StatelessWidget {
  final Uint8List imageBytes;

  const DisplayImagePage({Key? key, required this.imageBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: Image.memory(imageBytes),
      ),
    );
  }
}
