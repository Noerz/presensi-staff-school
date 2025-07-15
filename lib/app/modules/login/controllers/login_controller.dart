import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class LoginController extends GetxController {
  final _authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  RxBool isPasswordVisible = false.obs;
  final activeRole = 'Staff'.obs;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // RoleCode: 1 = Staff, 2 = Administrator
    final roleCode = activeRole.value == 'Administrator' ? 2 : 1;
    return await _authController.login(username: email, password: password);
  }
}
