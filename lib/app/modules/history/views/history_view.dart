import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi_school/app/widgets/custom_bottom_navigation_bar.dart';
import '../controllers/history_controller.dart';
import 'package:presensi_school/app/data/models/presensi_model.dart';

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
        onRefresh: () => controller.fetchPresensi(reset: true),
        child: Obx(() {
          if (controller.isLoading.value && controller.presensiList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.presensiList.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icon/empty_history.png', height: 200),
                      const SizedBox(height: 24),
                      Text(
                        "Belum Ada Riwayat Presensi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Riwayat presensi Anda akan muncul di sini.",
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
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.presensiList.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              if (index < controller.presensiList.length) {
                final presensi = controller.presensiList[index];
                final date =
                    DateTime.tryParse(presensi.inTime ?? '') ?? DateTime.now();
                final isToday = DateTime.now().difference(date).inDays == 0;

                return _buildPresensiCard(presensi, date, isToday);
              } else {
                return Obx(
                  () =>
                      controller.isFetchingMore.value
                          ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox.shrink(),
                );
              }
            },
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildPresensiCard(Presensi presensi, DateTime date, bool isToday) {
    final cardColor = isToday ? Colors.blue.shade50 : Colors.grey.shade100;
    final titleText =
        isToday ? 'Hari Ini' : DateFormat('EEEE', 'id_ID').format(date);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header tanggal
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  titleText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isToday ? Colors.blue : Colors.grey.shade700,
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

          // Konten presensi
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    title: "Masuk",
                    time: presensi.inTime?.split(" ").last ?? '-',
                    status: presensi.inKeterangan ?? '-',
                    isSuccess: presensi.inKeterangan == "Hadir",
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.more_horiz, color: Colors.grey),
                ),
                Expanded(
                  child: _buildTimeCard(
                    title: "Keluar",
                    time: presensi.outTime?.split(" ").last ?? '-',
                    status: presensi.outKeterangan ?? '-',
                    isSuccess: presensi.outKeterangan == "Hadir",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String time,
    required String status,
    required bool isSuccess,
  }) {
    final statusColor = isSuccess ? Colors.green : Colors.orange;
    final bgColor = isSuccess ? Colors.green.shade50 : Colors.orange.shade50;
    final icon = isSuccess ? Icons.check_circle : Icons.info;

    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: statusColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
