import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/widgets/CustomTextField.dart';
import 'package:presensi_school/app/core/widgets/custom_button.dart';
import 'package:presensi_school/app/modules/login/controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: const Color(0xfff6f6f6),
          body: SafeArea(
            child: Center(
              child: Container(
                width: constraints.maxWidth > 400 ? 400 : constraints.maxWidth,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      Image.asset(
                        'assets/images/login.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 26,
                          color: Color(0xff433878),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            CustomTextfield(
                              controller: controller.usernameController,
                              focusNode: FocusNode(),
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return '*Email is required';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return '*Invalid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              return CustomTextfield(
                                controller: controller.passwordController,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                suffixIcon: GestureDetector(
                                  onTap:
                                      () =>
                                          controller.isPasswordVisible.toggle(),
                                  child: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '*Password is required';
                                  }
                                  return null;
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        width: double.infinity,
                        height: 50,
                        text: "Login",
                        onPressed: () async {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            final result = await controller.login(
                              email: controller.usernameController.text,
                              password: controller.passwordController.text,
                            );
                            if (result['success']) {
                              Get.offAllNamed('/home');
                            } else {
                              Get.snackbar("Login Failed", result['message']);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Optional: forgot password
                      TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff7E60BF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
