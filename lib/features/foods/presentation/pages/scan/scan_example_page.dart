// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

// class ScanPageExample extends StatefulWidget {
//   const ScanPageExample({Key? key});

//   @override
//   State<ScanPageExample> createState() => _ScanPageExampleState();
// }

// class _ScanPageExampleState extends State<ScanPageExample> {
//   String text = "";
//   final StreamController<String> controller = StreamController<String>();

//   void setText(value) {
//     controller.add(value);
//   }

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Stack(
//         children: [
//           Container(
//             child: ScalableOCR(
//                 paintboxCustom: Paint()
//                   ..style = PaintingStyle.stroke
//                   ..strokeWidth = 4.0
//                   ..color = const Color.fromARGB(153, 102, 160, 241),
//                 boxLeftOff: 5,
//                 boxBottomOff: 2.5,
//                 boxRightOff: 5,
//                 boxTopOff: 2.5,
//                 boxHeight: MediaQuery.of(context).size.height / 3,
//                 getRawData: (value) {
//                   inspect(value);
//                 },
//                 getScannedText: (value) {
//                   setText(value);
//                 }),
//           ),
//           StreamBuilder<String>(
//             stream: controller.stream,
//             builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//               return Result(text: snapshot.data != null ? snapshot.data! : "");
//             },
//           ),
//         ],
//       )),
//     );
//   }
// }

// class Result extends StatelessWidget {
//   const Result({
//     Key? key,
//     required this.text,
//   }) : super(key: key);

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Text("Readed text: $text");
//   }
// }
