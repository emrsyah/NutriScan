import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nutriscan/theme.dart';

class ScanResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String name;

  const ScanResultPage({
    Key? key,
    required this.imageBytes,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Hasil Scan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
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
              SizedBox(height: 20,),
              Center(child: Text((name != "" ? name : "Nama Makanan"), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20), textAlign: TextAlign.center,)),
              SizedBox(height: 12,),
              Divider(color: graySecond,thickness: 0.6,),
              SizedBox(height: 12,),
              Text("Top Result", style: TextStyle(fontWeight: FontWeight.w600, color: gray, fontSize: 15), textAlign: TextAlign.start,)
            ],
          ),
        ),
      ),
    );
  }
}
