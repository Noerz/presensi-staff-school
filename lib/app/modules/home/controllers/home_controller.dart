import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/menu_model.dart';
import 'package:presensi_school/app/data/repository/profile_repository.dart';
import 'package:presensi_school/app/data/repository/school_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/core/const/keys.dart';

class HomeController extends GetxController {
  final _schoolRepository = Get.find<SchoolRepository>();
  final _profileRepository = Get.find<ProfileRepository>();
  final _secureStorage = Get.find<FlutterSecureStorage>();

  var nama = ''.obs;
  var profileImageUrl = ''.obs;
  var inTime = ''.obs;
  var outTime = ''.obs;

  var role = '1'.obs; // default siswa
  final menuItems = <MenuItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController onInit called');
    // Jangan panggil async di sini, gunakan onReady
  }

  @override
  void onReady() {
    super.onReady();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    await initRoleAndMenu();
    await fetchProfile();
    await fetchSchoolTimes();
    isLoading.value = false;
  }

  Future<void> initRoleAndMenu() async {
    final storedRole = await _secureStorage.read(key: Keys.roleCode);
    if (storedRole != null && storedRole.isNotEmpty) {
      role.value = storedRole;
    } else {
      role.value = '1'; // default siswa
    }
    loadMenuForRole(role.value);
  }

  Future<void> fetchProfile() async {
    try {
      final profile = await _profileRepository.getProfile();
      if (profile != null) {
        nama.value = profile.nama ?? 'Nama tidak tersedia';
        profileImageUrl.value = profile.image ?? "assets/images/person.png";
      } else {
        nama.value = 'Nama tidak tersedia';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  Future<void> fetchSchoolTimes() async {
    try {
      final school = await _schoolRepository.getSchoolById(
        '5c2fe877-dc5a-4c47-a46e-056b0c127517',
      );
      inTime.value = school.inTime;
      outTime.value = school.outTime;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load school times: $e');
    }
  }

  void loadMenuForRole(String role) {
    switch (role) {
      case '2': // guru
        menuItems.value = [
          MenuItem(
            label: "Masuk",
            iconPath: "assets/icon/masuk.png",
            route: "/presensi-masuk",
          ),
          MenuItem(
            label: "Keluar",
            iconPath: "assets/icon/keluar.png",
            route: "/presensi-keluar",
          ),
        ];
        break;
      case '3': // admin TU
        menuItems.value = [
          MenuItem(
            label: "Dashboard",
            iconPath: "assets/icon/masuk.png",
            route: "/admin-dashboard",
          ),
          MenuItem(
            label: "Kelola Guru",
            iconPath: "assets/icon/masuk.png",
            route: "/kelola-guru",
          ),
        ];
        break;
      case '1': // Administrator
      default:
        menuItems.value = [
          MenuItem(
            label: "Masuk",
            iconPath: "assets/icon/masuk.png",
            route: "/presensi-masuk",
          ),
          MenuItem(
            label: "Keluar",
            iconPath: "assets/icon/keluar.png",
            route: "/presensi-keluar",
          ),
          MenuItem(
            label: "Kelola Sekolah",
            iconPath: "assets/icon/sekolah.png",
            route: "/school",
          ),
          MenuItem(
            label: "Kelola User",
            iconPath: "assets/images/person.png",
            route: "/registrasi",
          ),
        ];
    }
  }
}
