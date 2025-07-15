import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_school/app/core/widgets/error_popup.dart';
import 'package:presensi_school/app/core/widgets/success_popup.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';
import 'package:presensi_school/app/data/repository/profile_repository.dart';
import 'package:presensi_school/app/modules/profile/controllers/profile_controller.dart';

class PresensiController extends GetxController {
  final _presensiRepository = Get.find<PresensiRepository>();
  final _profileRepository = Get.find<ProfileRepository>();
  final selectedDate = DateTime.now().obs;
  final nama = ''.obs;
  final nip = ''.obs; // NIP untuk presensi
  final gender = ''.obs; // Jenis kelamin untuk presensi
  var isLoading = false.obs;
  Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  RxBool isWithinRadius = false.obs; // Status radius

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await _profileRepository.getProfile();
      if (profile != null) {
        nama.value = profile.nama ?? 'Nama tidak tersedia';
        nip.value = profile.nip ?? 'NIP tidak tersedia';
        gender.value = profile.gender ?? 'Jenis kelamin tidak tersedia';
      } else {
        nama.value = 'Nama tidak tersedia';
        nip.value = 'NIP tidak tersedia';
        gender.value = 'Jenis kelamin tidak tersedia';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  void sendLocationToBackend(LatLng location, bool withinRadius) {
    selectedLocation.value = location;
    isWithinRadius.value = withinRadius;
    print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
  }

  Future<void> createPresensi({required String inLocation}) async {
    try {
      isLoading(true);
      var result = await _presensiRepository.createPresensiStaff(
        inLocation: inLocation,
      );
      print("Hasil dari result presensi: $result");
      if (result['success']) {
        // Presensi success
        SuccessPopup.show(
          message: "Data presensi berhasil dikirim!",
          route: '/home',
        );
      } else {
        String message = result['message'];
        if (message.contains("Presensi sudah dilakukan")) {
          ErrorPopup.show(
            message: "Anda sudah melakukan presensi sebelumnya.",
            route: '/home',
          );
        } else {
          ErrorPopup.show(message: message, route: '/home');
        }
      }
    } catch (e) {
      ErrorPopup.show(
        message: 'Terjadi kesalahan saat membuat presensi: $e',
        route: '/home',
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePresensi({required String outLocation}) async {
    try {
      isLoading(true);
      var result = await _presensiRepository.updatePresensiStaffOut(
        outLocation: outLocation,
      );
      print("Hasil dari result presensi: $result");
      if (result['success']) {
        // Presensi success
        SuccessPopup.show(
          message: "Data presensi berhasil dikirim!",
          route: '/home',
        );
      } else {
        String message = result['message'];
        if (message.contains("Presensi sudah dilakukan")) {
          ErrorPopup.show(
            message: "Anda sudah melakukan presensi sebelumnya.",
            route: '/home',
          );
        } else {
          ErrorPopup.show(message: message, route: '/home');
        }
      }
    } catch (e) {
      ErrorPopup.show(
        message: 'Terjadi kesalahan saat membuat presensi: $e',
        route: '/home-murid',
      );
    } finally {
      isLoading(false);
    }
  }

  void submitAttendance() {
    if (!isWithinRadius.value) {
      ErrorPopup.show(
        message:
            "Anda berada di luar radius sekolah. Silakan menuju lokasi sekolah untuk menggunakan fitur ini.",
        route: '/home',
      );
      return;
    }

    final DateTime selectedDateValue = selectedDate.value;
    final LatLng? location = selectedLocation.value;

    if (location != null) {
      String inLocation =
          "${location.latitude},${location.longitude}"; // Combine lat and lng for inLocation
      createPresensi(inLocation: inLocation);
    } else {
      ErrorPopup.show(
        message: "Harap lengkapi semua data sebelum mengirim presensi.",
        route: '/home',
      );
    }
  }

  void submitAttendanceOut() {
    if (!isWithinRadius.value) {
      ErrorPopup.show(
        message:
            "Anda berada di luar radius sekolah. Silakan menuju lokasi sekolah untuk menggunakan fitur ini.",
        route: '/home',
      );
      return;
    }

    final DateTime selectedDateValue = selectedDate.value;
    final LatLng? location = selectedLocation.value;

    if (location != null) {
      String outLocation =
          "${location.latitude},${location.longitude}"; // Combine lat and lng for inLocation
      updatePresensi(outLocation: outLocation);
    } else {
      ErrorPopup.show(
        message: "Harap lengkapi semua data sebelum mengirim presensi.",
        route: '/home',
      );
    }
  }
}
