import 'package:get/get.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';
import 'package:open_file/open_file.dart';

class ExportController extends GetxController {
  final repository = Get.find<PresensiRepository>();

  final isLoading = false.obs;

  Future<void> downloadPresensiExcel({
    int? bulan,
    int? tahun,
    String? userId,
  }) async {
    try {
      isLoading.value = true;

      final filePath = await repository.exportPresensiToExcel(
        bulan: bulan,
        tahun: tahun,
        userId: userId,
      );

      if (filePath != null) {
        Get.snackbar("Berhasil", "File berhasil diunduh");
        await OpenFile.open(filePath);
      } else {
        Get.snackbar("Gagal", "Gagal mengunduh file");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
