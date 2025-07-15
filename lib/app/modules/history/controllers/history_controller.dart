import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/presensi_model.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';

class HistoryController extends GetxController {
  final _presensiRepository = Get.find<PresensiRepository>();
  var isLoading = false.obs;
  var presensiList = <Presensi>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPresensi();
  }

  Future<void> fetchPresensi() async {
    try {
      isLoading.value = true;
      final result = await _presensiRepository.getPresensiByUser(
        page: 1,
        limit: 20,
      );
      presensiList.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
