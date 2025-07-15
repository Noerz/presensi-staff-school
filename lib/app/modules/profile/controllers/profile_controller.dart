import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/controllers/auth_controller.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:presensi_school/app/data/repository/profile_repository.dart';

class ProfileController extends GetxController {
  // Dependencies
  final AuthController _authController = Get.find<AuthController>();
  final ProfileRepository _profileRepository = Get.find<ProfileRepository>();
  final FlutterSecureStorage _secureStorage = Get.find<FlutterSecureStorage>();

  // State variables
  var isEditMode = false.obs; // Menandakan apakah dalam mode edit
  var isLoading = false.obs;
  var profile = Rx<User?>(null);
  var profileImageUrl = ''.obs;

  // NISN from secure storage
  var nisn = ''.obs;

  // Controllers for editable fields
  var usernameController = TextEditingController().obs;
  var noHandphoneController = TextEditingController().obs;
  var alamatController = TextEditingController().obs;
  var emailController = TextEditingController().obs;

  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    // Dispose controllers to avoid memory leaks
    usernameController.value.dispose();
    noHandphoneController.value.dispose();
    alamatController.value.dispose();
    emailController.value.dispose();
    super.onClose();
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Kualitas gambar (0-100)
        maxWidth: 800, // Lebar maksimum
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        await updateProfilePicture();
      } else {
        Get.snackbar(
          'Peringatan',
          'Tidak ada gambar yang dipilih',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Error picking image: $e');
    }
  }

  /// Fetch profile data from the repository
  Future<void> fetchProfile() async {
  try {
    isLoading(true);
    final userProfile = await _profileRepository.getProfile();
    if (userProfile != null) {
      profile.value = userProfile;

      // Update nilai pada controllers
      usernameController.value.text = userProfile.nama ?? '';
      noHandphoneController.value.text = userProfile.noHp ?? '';
      alamatController.value.text = userProfile.alamat ?? '';
      emailController.value.text = userProfile.auth?.email ?? '';

      // Update profile image URL
      profileImageUrl.value = userProfile.image ?? '';

      // Simpan nama ke secure storage
      await _setStorage({"username": userProfile.nama ?? ''});
    } else {
      Get.snackbar("Error", "Data profil kosong!");
    }
  } catch (e) {
    Get.snackbar("Error", "Gagal memuat profil: $e");
  } finally {
    isLoading(false);
  }
}


  /// Toggle edit mode and save changes
  Future<void> toggleEditMode() async {
    if (isEditMode.value) {
      // Jika kita keluar dari mode edit, simpan perubahan
      await saveProfileChanges();
    } else {
      // Masuk ke mode edit
      isEditMode.value = true;
    }
  }

  /// Save the updated profile data
  Future<void> saveProfileChanges() async {
    try {
      // Ambil data yang sudah diubah dari TextEditingController
      final updatedProfile = {
        "username": usernameController.value.text,
        "no_handphone": noHandphoneController.value.text,
        "alamat": alamatController.value.text,
      };

      // Simpan data nama ke secure storage
      await _setStorage({"username": updatedProfile["username"]!});

      var result = await _profileRepository.updateProfile(
        fullName: updatedProfile["username"] ?? '',
        adress: updatedProfile["alamat"] ?? '',
        noHp: updatedProfile["no_handphone"] ?? '',
      );
      print("Hasil dari result profile $result");
      // Simpan data ke repository atau API (implementasi sesuai kebutuhan)
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan perubahan: $e");
    } finally {
      isEditMode.value =
          false; // Keluar dari mode edit setelah menyimpan perubahan
    }
  }

  /// Simpan nama ke secure storage
  Future<void> _setStorage(Map<String, String> updatedProfile) async {
    try {
      // Menyimpan data ke secure storage jika diperlukan
      // await _secureStorage.write(key: Keys.nama, value: updatedProfile["username"]);
    } catch (e) {
      print('Error saat menyimpan data ke secure storage: $e');
      rethrow;
    }
  }

  Future<void> refreshProfile() async {
    try {
      isLoading(true);
      await fetchProfile(); // Memuat ulang data profil
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat ulang profil: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Logout functionality
  Future<Map<String, dynamic>> logout() async {
    return await _authController.logout();
  }

  Future<void> updateProfilePicture() async {
    try {
      if (profileImage.value != null) {
        await _profileRepository.updateProfilePicture(profileImage.value!);
        Get.snackbar("Success", "Foto profil berhasil diperbarui");
        refreshProfile();
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui foto profil: $e");
    }
  }
}
