import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/widgets/custom_icon.dart';
import 'package:presensi_school/app/modules/home/controllers/home_controller.dart';
import 'package:presensi_school/app/widgets/custom_bottom_navigation_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            );
          }

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A7DFF), // Warna biru modern
                      Color(0xFFB0C7FF), // Warna biru muda
                    ],
                  ),
                ),
              ),
              
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/background1.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  opacity: const AlwaysStoppedAnimation(0.3),
                ),
              ),
              
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dengan avatar dan teks
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                controller.profileImageUrl.value,
                              ),
                              radius: 24,
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  final nama = controller.nama.value.isNotEmpty
                                      ? controller.nama.value
                                      : 'Nama tidak tersedia';
                                  return Text(
                                    'Hai, $nama',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                                const SizedBox(height: 4),
                                const Text(
                                  'Selamat datang di Presensi Online Apps',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Menu Statistik dalam grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: controller.menuItems.map((menu) {
                          return CustomIconButton(
                            assetIconPath: menu.iconPath,
                            size: 40,
                            label: menu.label,
                            isLabelAbove: false,
                            onPressed: () {
                              Get.toNamed(menu.route);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Kehadiran waktu masuk dan keluar
                      const Text(
                        "Waktu Sekolah Hari Ini",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _attendanceCard(
                              time: controller.inTime.value,
                              label: "Masuk",
                              color: const Color(0xFF4A7DFF),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _attendanceCard(
                              time: controller.outTime.value,
                              label: "Keluar",
                              color: const Color(0xFFFF7043),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Informasi tambahan
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tips Presensi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "• Pastikan GPS aktif saat melakukan presensi\n"
                              "• Presensi masuk hanya bisa dilakukan di area sekolah\n"
                              "• Presensi keluar bisa dilakukan setelah jam pulang",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  // Widget untuk kartu kehadiran
  Widget _attendanceCard({required String time, required String label, required Color color}) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}