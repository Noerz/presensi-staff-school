import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/presensi_model.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';

class HistoryController extends GetxController {
  final _presensiRepository = Get.find<PresensiRepository>();

  var isLoading = false.obs;
  var isFetchingMore = false.obs;
  var presensiList = <Presensi>[].obs;
  late ScrollController scrollController;

  int page = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);

    if (!isInitialized) {
      fetchPresensi(reset: true);
      isInitialized = true;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      fetchPresensi();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchPresensi({bool reset = false}) async {
    if (reset) {
      page = 1;
      hasMore = true;
    }

    if ((!hasMore && !reset) || isLoading.value || isFetchingMore.value) return;

    try {
      if (reset) {
        isLoading.value = true;
      } else {
        isFetchingMore.value = true;
      }

      final result = await _presensiRepository.getPresensiByUser(
        page: page,
        limit: limit,
      );

      if (reset) {
        presensiList.assignAll(result);
      } else {
        presensiList.addAll(result);
      }

      if (result.length < limit) {
        hasMore = false;
      }

      if (!reset && result.isNotEmpty) {
        page++;
      } else if (reset) {
        page = 2;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }
}
