import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:nutriscan/theme.dart';

class HomeTopBar extends StatelessWidget {
  HomeTopBar({
    super.key,
    required this.name,
  });

  final name;

  // Avatar _avatar = DiceBearBuilder(
  //   sprite: DiceBearSprite.micah,
  //   seed: "something", // Default seed is an empty string if you don't set it
  //   // size: 1
  // ).build();

  @override
  Widget build(BuildContext context) {
    Avatar _avatar = DiceBearBuilder(
      sprite: DiceBearSprite.loreleiNeutral,
      seed: name,
      // size: 1
    ).build();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Datang 👋",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                    fontSize: 16),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: graySecond, // Adjust border color as needed
                width: 0.5, // Adjust border width as needed
              ),
            ),
            child: ClipOval(
              child: _avatar.toImage(height: 48, width: 48),
            ),
          )
        ],
      ),
    );
  }
}
