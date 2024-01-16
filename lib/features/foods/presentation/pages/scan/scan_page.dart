import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_result_page.dart';
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
  final StreamController<String> controller = StreamController<String>();
  late String scannedText = '';
  String _myText = "";

  void setText(value) {
    controller.add(value);
    _myText = value;
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
                        ..color = const Color.fromARGB(153, 102, 160, 241),
                      boxLeftOff: 4,
                      boxBottomOff: 2.7,
                      boxRightOff: 4,
                      boxTopOff: 2.7,
                      boxHeight: MediaQuery.of(context).size.height / 4,
                      getRawData: (value) {
                        inspect(value);
                      },
                      getScannedText: (value) {
                        setText(value);
                      },
                      onCaptureImage: (Uint8List imageBytes) async {
                        String base64Image = base64Encode(imageBytes);
                        // Wait for the getScannedText callback to complete
                        print("halo");
                        // print(_myText);
                        if (_myText != null && _myText != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScanResultPage(
                                imageBytes: imageBytes,
                                name: _myText,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Teks belum terscan"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
              padding: EdgeInsets.only(top: 36, right: 20, left: 20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder<String>(
                      stream: controller.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return (snapshot.data != null && snapshot.data != "")
                            ? Text(
                                snapshot.data!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: primary),
                              )
                            : Text(
                                "Melakukan Scanning...",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              );
                        // return Result(
                        //     text: (snapshot.data != null && snapshot.data != "")
                        //         ? snapshot.data!
                        //         : "Melakukan Scanning...");
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          ScalableOCRState? ocrState =
                              widget.ocrKey.currentState;
                          if (ocrState != null) {
                            ocrState.handleCaptureImage();
                          }
                        },
                        child: Text(
                          "Konfirmasi",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
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
