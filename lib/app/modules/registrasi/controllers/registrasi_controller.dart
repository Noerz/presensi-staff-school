import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/role_model.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:presensi_school/app/data/repository/auth_repository.dart';
import 'package:presensi_school/app/data/repository/role_repository.dart';

class RegistrasiController extends GetxController {
  final AuthRepository authRepo = Get.find();
  final RoleRepository roleRepo = Get.find();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final selectedRoleId = ''.obs; // Menyimpan ID role

  final users = <User>[].obs;
  final roles = <Role>[].obs;
  final isLoading = false.obs;
  final isLoadingRoles = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();

    // Debug: Listen to roles changes
    ever(roles, (_) {
      debugPrint('[DEBUG] Roles updated: ${roles.length} items');
      if (roles.isNotEmpty) {
        debugPrint('[DEBUG] First role: ${roles.first.toJson()}');
        debugPrint('[DEBUG] Selected role ID: $selectedRoleId');
      }
    });
  }

  Future<void> loadData() async {
    await loadRoles();
    await loadUsers();
  }

  Future<void> loadRoles() async {
    try {
      isLoadingRoles(true);
      final result = await roleRepo.getRoles();
      roles.assignAll(result);

      // Set default role hanya jika ada data
      if (roles.isNotEmpty) {
        selectedRoleId.value =
            roles.first.idRole; // Gunakan langsung idRole (String)
      }
    } catch (e) {
      errorMessage.value = 'Failed to load roles: $e';
    } finally {
      isLoadingRoles(false);
    }
  }

  Future<void> loadUsers() async {
    try {
      debugPrint('[DEBUG] Loading users...');
      isLoading(true);
      // Implement your get users logic here
      // Example: users.value = await authRepo.getUsers();
    } catch (e) {
      debugPrint('[ERROR] Failed to load users: $e');
      errorMessage.value = 'Failed to load users: $e';
    } finally {
      isLoading(false);
      debugPrint('[DEBUG] Users loading completed');
    }
  }

  // Getter untuk role yang dipilih
  Role? get selectedRole {
    try {
      return roles.firstWhere(
        (role) => int.tryParse(role.idRole.toString()) == selectedRoleId.value,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> registerUser() async {
    try {
      debugPrint('[DEBUG] Registering user...');
      debugPrint('Full Name: \\${fullNameController.text}');
      debugPrint('Email: \\${emailController.text}');
      debugPrint('Password: \\${passwordController.text}');
      debugPrint('Role ID: $selectedRoleId');

      isLoading(true);
      final roleCode = selectedRole?.code ?? 2; // Ambil code dari role yang dipilih
      final result = await authRepo.register(
        fullName: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        roleCode: roleCode, // Kirim code sebagai int
      );

      if (result['success']) {
        debugPrint('[SUCCESS] User created successfully');
        Get.snackbar(
          'Success',
          'User created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        loadUsers();
      } else {
        debugPrint('[ERROR] Failed to create user: ${result['message']}');
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to create user',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('[EXCEPTION] Failed to create user: $e');
      Get.snackbar(
        'Error',
        'Failed to create user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  String getRoleName(int roleId) {
    try {
      final role = roles.firstWhere(
        (role) => int.tryParse(role.idRole.toString()) == roleId,
      );
      debugPrint('[DEBUG] Found role for ID $roleId: \\${role.nama}');
      return role.nama;
    } catch (e) {
      debugPrint('[WARNING] Role not found for ID $roleId');
      return 'Unknown';
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      debugPrint('[DEBUG] Deleting user: $userId');
      isLoading(true);
      // Implement your delete user logic here
      // Example: await authRepo.deleteUser(userId);
      loadUsers();
      debugPrint('[SUCCESS] User deleted successfully');
      Get.snackbar(
        'Success',
        'User deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('[ERROR] Failed to delete user: $e');
      Get.snackbar(
        'Error',
        'Failed to delete user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    // Reset ke role pertama jika ada data
    if (roles.isNotEmpty) {
      selectedRoleId.value = roles.first.idRole;
    } else {
      selectedRoleId.value = '';
    }
  }
}
