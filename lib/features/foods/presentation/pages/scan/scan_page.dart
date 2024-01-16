import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/display_image.dart';
import 'dart:developer';
import 'package:nutriscan/theme.dart';
import 'package:nutriscan/utils/lib/scalable_ocr.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key? key});

  final GlobalKey<ScalableOCRState> ocrKey = GlobalKey<ScalableOCRState>();

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // First Section (Covers the entire area)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [softDrop],
                              border: softBorder,
                              borderRadius: BorderRadius.circular(6)),
                          child: Icon(Icons.chevron_left_rounded, size: 32),
                        ),
                        Text(
                          "Scan Makanan",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          width: 48,
                          height: 48,
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: ScalableOCR(
                      key: widget.ocrKey,
                      paintboxCustom: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4.0
                        ..color = HexColor('#25A35F'),
                      boxLeftOff: 8,
                      boxRightOff: 8,
                      boxHeight: MediaQuery.of(context).size.height / 2,
                      getRawData: (value) {
                        inspect(value);
                      },
                      getScannedText: (value) {
                        setText(value);
                      },
                      onCaptureImage: (Uint8List imageBytes) {
                        // Handle the captured image bytes here
                        // You can save it to storage, send it to a server, etc.
                        String base64Image = base64Encode(imageBytes);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            DisplayImagePage(imageBytes: imageBytes)
                          ),
                        );
                        print("halooo");
                        print(
                            'Image captured successfully! Base64: $base64Image');
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Second Section (Fixed height of 240)
            Container(
              height: 240.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [softDrop],
                border: softBorder,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: controller.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Result(
                            text: snapshot.data != null
                                ? snapshot.data!
                                : "Melakukan Scanning...");
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        print("tesss");
                        // Trigger image capture when button is pressed
                        // ScalableOCRState? ocrState =
                        ScalableOCRState? ocrState = widget.ocrKey.currentState;
                        print(ocrState);
                        if (ocrState != null) {
                          print("helo boi");
                          ocrState.handleCaptureImage();
                        }
                      },
                      child: Text("Konfirmasi"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
