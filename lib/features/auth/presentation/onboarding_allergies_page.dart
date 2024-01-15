import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/theme.dart';

class OnboardingAllergiesPage extends ConsumerStatefulWidget {
  const OnboardingAllergiesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingAllergiesPageState();
}

class _OnboardingAllergiesPageState extends ConsumerState<OnboardingAllergiesPage> {
  final _data = [
    {
      "label": "Sea Food",
      "value": "Seafood",
      "status": "OK",
    },
    {
      "label": "Kacang-kacangan",
      "value": "Nut",
      "status": "OK",
    },
    {
      "label": "Dairy Product (Susu, Telur, dll)",
      "value": "Milk, Eggs, Other Dairy",
      "status": "OK",
    },
    {
      "label": "Daging",
      "value": "Meat",
      "status": "OK",
    },
    {
      "label": "Roti & Bakery Product",
      "value": "Bakery/Bread",
      "status": "OK",
    },
    {
      "label": "Selai Kacang, Jams, Madu, ",
      "value": "Nut butters, Jams, and Honey",
      "status": "OK",
    },
    {
      "label": "Buah-buahan kering",
      "value": "Dried Fruits",
      "status": "OK",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              const Text(
                "Atur Data Alergimu 🥑",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Tap alergi, terdapat 3 pilihan untuk tiap alergi",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              const SizedBox(
                height: 48,
              ),
              const Text(
                "(Kamu bisa ubah ini nanti dibagian profil)",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        AllergiesToggleButton(
                          label: _data[index]["label"]!,
                          status: _data[index]["status"]!,
                          onTap: () {
                            setState(() {
                              switch (_data[index]["status"]) {
                                case 'OK':
                                  _data[index]["status"] = 'WARN';
                                  break;
                                case 'WARN':
                                  _data[index]["status"] = 'NO';
                                  break;
                                case 'NO':
                                  _data[index]["status"] = 'OK';
                                  break;
                                default:
                                  break;
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).setAllergies(context, _data);
                  },
                  child: const Text(
                    "Konfirmasi & Selesai",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AllergiesToggleButton extends StatelessWidget {
  const AllergiesToggleButton({
    super.key,
    required this.label,
    required this.status,
    required this.onTap,
  });

  final String label;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color textColor;
    String icon;
    switch (status) {
      case 'OK':
        borderColor = Colors.green;
        textColor = Colors.green;
        icon = "assets/image/ok-icon.png";
        break;
      case 'WARN':
        borderColor = HexColor("#FFC107");
        textColor = HexColor("#FFC107");
        icon = "assets/image/warn-icon.png";
        break;
      case 'NO':
        borderColor = Colors.red;
        textColor = Colors.red;
        icon = "assets/image/no-icon.png";
        break;
      default:
        borderColor = Colors.grey;
        textColor = Colors.grey;
        icon = "err";
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 0.7, color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
            Image.asset(icon, height: 16, width: 16,)
            // Text(
            //   icon,
            //   style: TextStyle(color: textColor),
            // ),
          ],
        ),
      ),
    );
  }
}
