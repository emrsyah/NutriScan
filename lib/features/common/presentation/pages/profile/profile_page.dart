import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/common_widget/BottomNavigation.dart';
import 'package:nutriscan/theme.dart';
import 'package:dice_bear/dice_bear.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "Profil Anda 👤",
            style:
                TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          shape: Border(
            bottom: BorderSide(
              color: graySecond,
              width: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: ClipOval(
                      child: Container(
                        width: 64,
                        height: 64,
                        child: DiceBearBuilder(
                          sprite: DiceBearSprite.loreleiNeutral,
                          seed: ref.read(authControllerProvider).name!,
                          // size: 1
                        ).build().toImage(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.read(authControllerProvider).name!, textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      Text(
                        ref.read(authControllerProvider).email!, textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16, color: gray),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  // constraints: BoxConstraints.expand(),
                ),
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut(context);
                },
                child: Container(
                  width: double.infinity,
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(idx: 4),
      ),
    );
  }
}
