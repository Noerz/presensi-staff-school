import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/export_controller.dart';

class ExportView extends GetView<ExportController> {
  const ExportView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchUsers();
    final TextEditingController userIdController = TextEditingController();
    final RxInt selectedBulan = 1.obs;
    final RxInt selectedTahun = DateTime.now().year.obs;

    final List<String> bulanList = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Rekap Presensi'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Export',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Dropdown User
                DropdownButtonFormField<String>(
                  value: controller.selectedUserId.value,
                  decoration: InputDecoration(
                    labelText: 'Pilih User (Opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  isExpanded: true,
                  items:
                      controller.users.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.idUser,
                          child: Text(
                            "${user.nama} (${user.nip})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    controller.selectedUserId.value = value;
                  },
                ),
                const SizedBox(height: 16),
                // Dropdown Bulan
                DropdownButtonFormField<int>(
                  value: selectedBulan.value,
                  decoration: InputDecoration(
                    labelText: 'Bulan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text(bulanList[index]),
                    ),
                  ),
                  onChanged: (value) {
                    selectedBulan.value = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Dropdown Tahun
                DropdownButtonFormField<int>(
                  value: selectedTahun.value,
                  decoration: InputDecoration(
                    labelText: 'Tahun',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: List.generate(5, (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (value) {
                    selectedTahun.value = value!;
                  },
                ),
                const SizedBox(height: 24),
                // Tombol download
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                              controller.downloadPresensiExcel(
                                bulan: selectedBulan.value,
                                tahun: selectedTahun.value,
                                userId: controller.selectedUserId.value,
                              );
                            },
                    icon:
                        controller.isLoading.value
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Icon(Icons.download),
                    label: const Text("Download Rekap Presensi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
