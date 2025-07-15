import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF6F2DBD),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Riwayat Presensi"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        // Tambahkan item baru di sini jika ada halaman baru
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed("/home");
            break;
          case 1:
            Get.offAllNamed("/history");
            break;
          case 2:
            Get.offAllNamed("/profile");
            break;
          // Tambahkan case baru jika ada halaman baru
        }
      },
    );
  }
}
