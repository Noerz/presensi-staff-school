import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:presensi_school/app/data/repository/auth_repository.dart';
import 'package:presensi_school/app/modules/home/controllers/home_controller.dart';

class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final _secureStorage = Get.find<FlutterSecureStorage>();

  User? userAccount;

  @override
  void onReady() {
    super.onReady();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));

    final token = await _secureStorage.read(key: Keys.token);

    if (token != null) {
      final isValid = await _authRepository.validateToken(token);
      if (isValid) {
        print('Token valid, lanjut ke home');

        final tempUserId = await _secureStorage.read(key: Keys.id) ?? '';
        print("User ID dari storage: $tempUserId");

        userAccount = User(accessToken: token);
        Get.offAllNamed('/home');
        return;
      } else {
        print('Token tidak valid, hapus storage dan redirect ke login');
        await _clearStorage();
      }
    }

    Get.offAllNamed('/login');
  }

  /// Simpan token dan data user ke secure storage
  Future<void> _setStorage() async {
    try {
      if (userAccount != null) {
        await _secureStorage.write(
          key: Keys.token,
          value: userAccount!.accessToken,
        );
        await _secureStorage.write(
          key: Keys.roleCode,
          value: userAccount!.roleCode?.toString() ?? '',
        );

        // Debug: Print stored values
        print('Data berhasil disimpan ke secure storage:');
        print('Token: ${await _secureStorage.read(key: Keys.token)}');
        print('Role Code: ${await _secureStorage.read(key: Keys.roleCode)}');
      }
    } catch (e) {
      print('Error saat menyimpan data ke secure storage: $e');
      rethrow;
    }
  }

  /// Hapus semua data user dari secure storage
  Future<void> _clearStorage() async {
    try {
      await _secureStorage.deleteAll(); // Hapus semua data
      print('Semua data user berhasil dihapus dari storage.');
    } catch (e) {
      print('Error saat menghapus data dari secure storage: $e');
      rethrow;
    }
  }

  /// Fungsi login menggunakan email, password, dan roleCode
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Step 1: Login ke API
      userAccount = await _authRepository.login(
        username: username,
        password: password,
      );

      if (userAccount == null) {
        throw Exception('User account is null');
      }

      print('Login berhasil, data user: ${userAccount?.accessToken ?? 'N/A'}');

      // Step 2: Simpan data user ke secure storage
      await _setStorage();

      // Pindahkan navigasi ke home ke sini, setelah storage update
      Get.delete<HomeController>(force: true);
      Get.offAllNamed('/home');

      return {
        'success': true,
        'message': 'Login berhasil.',
        'roleCode': userAccount!.roleCode,
      };
    } on DioError catch (e) {
      String errorMessage = 'Login gagal. Silakan coba lagi.';
      if (e.response?.data != null) {
        final responseMessage = e.response?.data['message'];
        if (responseMessage == 'Email not found') {
          errorMessage = 'Email tidak ditemukan.';
        } else if (responseMessage == 'Wrong password') {
          errorMessage = 'Password salah.';
        }
      }
      print('Login gagal: ${e.response?.data}');
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      print('Login gagal: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan. Silakan coba lagi.',
      };
    }
  }

  /// Fungsi logout
  Future<Map<String, dynamic>> logout() async {
    try {
      // Step 1: Hapus data user dari storage
      await _clearStorage();
      Get.delete<HomeController>(force: true);
      Get.offAllNamed('/login'); // Navigasi ke halaman Login
      return {'success': true, 'message': 'Logout berhasil.'};
    } catch (e) {
      print('Logout gagal: $e');
      return {'success': false, 'message': 'Logout gagal. Silakan coba lagi.'};
    }
  }
}
