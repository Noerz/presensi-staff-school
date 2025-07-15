import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import '../controllers/registrasi_controller.dart';

class RegistrasiView extends GetView<RegistrasiController> {
  RegistrasiView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.nipController,
                        decoration: InputDecoration(
                          labelText: 'NIP',
                          prefixIcon: const Icon(Icons.badge),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter NIP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (controller.isLoadingRoles.value) {
                          return const CircularProgressIndicator();
                        }

                        if (controller.roles.isEmpty) {
                          return const Text('No roles available');
                        }

                        return DropdownButtonFormField<String>(
                          // Pastikan nilai valid sebelum ditampilkan
                          value:
                              controller.roles.any(
                                    (role) =>
                                        role.idRole ==
                                        controller.selectedRoleId.value,
                                  )
                                  ? controller.selectedRoleId.value
                                  : null,
                          onChanged: (String? newValue) {
                            if (newValue != null)
                              controller.selectedRoleId.value = newValue;
                          },
                          items:
                              controller.roles.map((role) {
                                return DropdownMenuItem<String>(
                                  value:
                                      role.idRole, // Gunakan nilai asli (String)
                                  child: Text(role.nama),
                                );
                              }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Role',
                            prefixIcon: const Icon(Icons.people),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator:
                              (value) =>
                                  value == null ? 'Please select a role' : null,
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.registerUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'REGISTER USER',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // List Header
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'User List',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.deepPurple,
            //         ),
            //       ),
            //       Obx(
            //         () => Text(
            //           'Total: ${controller.users.length}',
            //           style: const TextStyle(color: Colors.grey),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 12),
            // // List Section
            // Expanded(
            //   child: Obx(() {
            //     if (controller.isLoading.value) {
            //       return const Center(child: CircularProgressIndicator());
            //     }

            //     if (controller.users.isEmpty) {
            //       return const Center(
            //         child: Text(
            //           'No users found',
            //           style: TextStyle(color: Colors.grey),
            //         ),
            //       );
            //     }

            //     return RefreshIndicator(
            //       onRefresh: controller.loadData,
            //       child: ListView.builder(
            //         itemCount: controller.users.length,
            //         itemBuilder: (context, index) {
            //           final user = controller.users[index];
            //           final role = controller.getRoleName(user.roleCode!);

            //           return _buildUserCard(user, role);
            //         },
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user, String roleName) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(roleName).withOpacity(0.2),
          child: Icon(_getRoleIcon(roleName), color: _getRoleColor(roleName)),
        ),
        title: Text(
          user.nama!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.auth!.email ?? 'No email provided'),
            const SizedBox(height: 4),
            Text(
              roleName.toUpperCase(),
              style: TextStyle(
                color: _getRoleColor(roleName),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => controller.deleteUser(user.idUser!),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.deepPurple;
      case 'teacher':
        return Colors.blue;
      case 'student':
        return Colors.green;
      case 'parent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'teacher':
        return Icons.school;
      case 'student':
        return Icons.person;
      case 'parent':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }
}
