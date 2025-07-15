import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/widgets/custom_bottom_navigation_bar.dart';
import '../controllers/history_controller.dart';
import 'package:intl/intl.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Presensi',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await controller.fetchPresensi(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            );
          }

          if (controller.presensiList.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/icon/empty_history.png', // Ganti dengan asset Anda
                        height: 200,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Belum Ada Riwayat Presensi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Riwayat presensi Anda akan muncul di sini",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: controller.presensiList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final presensi = controller.presensiList[index];
              final date = DateTime.parse(presensi.inTime ?? '');
              final isToday = DateTime.now().difference(date).inDays == 0;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isToday ? Colors.blue.shade50 : Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: isToday ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isToday
                                ? "Hari Ini"
                                : DateFormat('EEEE', 'id_ID').format(date),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  isToday ? Colors.blue : Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('dd MMM yyyy', 'id_ID').format(date),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          _buildTimeCard(
                            title: "Masuk",
                            time: presensi.inTime?.split(" ").last ?? '-',
                            status: presensi.inKeterangan ?? '-',
                            isSuccess: presensi.inKeterangan == "Hadir",
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.more_horiz, color: Colors.grey),
                          const SizedBox(width: 24),
                          _buildTimeCard(
                            title: "Keluar",
                            time: presensi.outTime?.split(" ").last ?? '-',
                            status: presensi.outKeterangan ?? '-',
                            isSuccess: presensi.outKeterangan == "Hadir",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String time,
    required String status,
    required bool isSuccess,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.info,
                  size: 12,
                  color: isSuccess ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSuccess ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
