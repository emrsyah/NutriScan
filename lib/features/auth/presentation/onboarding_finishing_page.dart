import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingFinishing extends StatefulWidget {
  const OnboardingFinishing({Key? key});

  @override
  _OnboardingFinishingState createState() => _OnboardingFinishingState();
}

class _OnboardingFinishingState extends State<OnboardingFinishing> {
  int currentTextIndex = 0;
  List<String> texts = [
    "Menyiapkan Preferensi Alergi Anda...",
    "Personalisasi Rekomendasi Makanan...",
    "Menyesuaikan Pengalaman Nutriscan Anda...",
  ];

  late Timer textChangeTimer;

  @override
  void initState() {
    super.initState();
    textChangeTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        currentTextIndex = (currentTextIndex + 1) % texts.length;
      });
    });

    // Trigger navigation after 7 seconds
    Future.delayed(Duration(seconds: 7), () {
      context.pushReplacementNamed("home");
    });
  }

  @override
  void dispose() {
    textChangeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lottie/cooking-lottie.json",
                    width: 300, height: 300),
                Text(
                  texts[currentTextIndex],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
