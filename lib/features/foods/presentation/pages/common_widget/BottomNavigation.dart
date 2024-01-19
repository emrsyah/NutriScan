import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/theme.dart';

class BottomNavigation extends StatelessWidget {
  final int idx;

  const BottomNavigation({Key? key, required this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        boxShadow: [
          softDrop,
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: idx, // Set the initial selected index
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white, // Adjust the background color as needed
        iconSize: 28,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        // Handle navigation item taps
        onTap: (index) {
          // Add your navigation logic here
          if (index == 0) {
            context.pushNamed("home");
          } else if (index == 1) {
            print("not yet ready");
          } else if (index == 3) {
            context.pushNamed("donation");
          } else if (index == 4) {
            context.pushNamed("profile");
          }
        },

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => {context.pushNamed('scan')},
              child: Container(
                width: 72.0,
                height: 72.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF25A35F), // Background color #25A35F
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.integration_instructions),
            label: 'Donasi',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
