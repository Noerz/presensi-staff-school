import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_school/app/core/widgets/maps/gps_map_widget.dart';
import 'package:presensi_school/app/core/widgets/staff_info_card.dart';
import 'package:presensi_school/app/core/widgets/custom_app_bar.dart';
import 'package:presensi_school/app/core/widgets/date_selector.dart';
import 'package:intl/intl.dart';
import '../controllers/presensi_controller.dart';

class PresensiMasukView extends GetView<PresensiController> {
  const PresensiMasukView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: CustomAppBar(
              title: "Presensi Masuk",
              onBackPressed: () => Get.offAllNamed('/home'),
              elevation: 4,
              backgroundColor: const Color(0xFF5E348E),
            ),
            body: Center(
              child: Container(
                width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      _buildSectionHeader(
                        "Tanggal Presensi",
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 12),
                      DateSelector(
                        onDateSelected: (selectedDate) {
                          controller.selectedDate.value = selectedDate;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Display
                      Obx(() {
                        final selectedDate = controller.selectedDate.value;
                        final formattedDate = _formatDate(selectedDate);
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Color(0xFF5E348E),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "$formattedDate",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Staff Info Section
                      _buildSectionHeader("Identitas Pegawai", Icons.person),
                      const SizedBox(height: 12),
                      Obx(() {
                        final nama =
                            controller.nama.value.isNotEmpty
                                ? controller.nama.value
                                : 'Nama tidak tersedia';
                        final nip =
                            controller.nip.value.isNotEmpty
                                ? controller.nip.value
                                : 'NIP tidak tersedia';
                        final gender =
                            controller.gender.value.isNotEmpty
                                ? controller.gender.value
                                : 'Jenis kelamin tidak tersedia';
                        return StaffInfoCard(
                          name: nama,
                          position: "Staff Sekolah",
                          nip: nip,
                          gender: gender,
                        );
                      }),

                      const SizedBox(height: 24),

                      // Lokasi Section
                      _buildSectionHeader("Lokasi Terkini", Icons.location_on),
                      const SizedBox(height: 12),

                      // Waktu Realtime
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Pembaruan Otomatis",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          StreamBuilder<DateTime>(
                            stream: Stream.periodic(
                              const Duration(seconds: 1),
                              (_) => DateTime.now(),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final time = snapshot.data!;
                                return Chip(
                                  backgroundColor: const Color(
                                    0xFF5E348E,
                                  ).withOpacity(0.1),
                                  label: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Color(0xFF5E348E),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatTime(time),
                                        style: const TextStyle(
                                          color: Color(0xFF5E348E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const Text("Memuat...");
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Map Widget dengan loading
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              MapWidget(
                                onLocationFetched:
                                    controller.sendLocationToBackend,
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        margin: const EdgeInsets.only(right: 6),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF5E348E),
                                        ),
                                      ),
                                      Text(
                                        "Memperbarui Lokasi",
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: const Color(0xFF5E348E),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Submit Button dengan animasi
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.submitAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5E348E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            shadowColor: const Color(
                              0xFF5E348E,
                            ).withOpacity(0.3),
                            textStyle: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check_circle, size: 20),
                              SizedBox(width: 8),
                              Text("Kirim Presensi"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5E348E), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E348E),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final weekdayName = weekdays[date.weekday - 1];
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return '$weekdayName, $formattedDate';
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }
}
