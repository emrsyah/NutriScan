import 'package:flutter/material.dart';


class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Selamat Datang 👋", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), Text("Pengguna ", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black45, fontSize: 16),)],
          ),
          ClipOval(
            child: Image.network(
                "https://i.pinimg.com/originals/fb/04/8b/fb048b34530a5ca7de5ebef72202fa1e.png",
                width: 48,
                height: 48,
                fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}
