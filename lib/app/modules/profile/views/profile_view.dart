import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/core/utils/promt_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi_school/app/widgets/custom_bottom_navigation_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch profile data when the page is opened
    // controller.fetchProfile();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Center(
            child: Container(
              width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
              child: SafeArea(
                child: Column(
                  children: [
                    // Bagian Header
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF433878), // Warna ungu
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Obx(
                                  () => Icon(
                                    controller.isEditMode.value
                                        ? Icons.check
                                        : Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  await controller
                                      .toggleEditMode(); // Toggle edit mode
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // Radius all 8
                                    image: DecorationImage(
                                      image:
                                          controller
                                                  .profileImageUrl
                                                  .value
                                                  .isNotEmpty
                                              ? NetworkImage(
                                                controller
                                                    .profileImageUrl
                                                    .value,
                                              )
                                              : const AssetImage(
                                                    'assets/images/login.png',
                                                  )
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await controller.pickImageFromGallery();
                                    },
                                    // child: Container(
                                    //   padding: const EdgeInsets.all(8),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: const Icon(
                                    //     Icons.camera_alt,
                                    //     color: Colors.black54,
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final user = controller.profile.value;
                                final nip =
                                    user?.nip != null &&
                                            user?.nip.toString().isNotEmpty ==
                                                true
                                        ? user?.nip.toString()
                                        : null;
                                return Text(
                                  nip != null ? "NIP : $nip" : "NISN : -",
                                  style: const TextStyle(color: Colors.white),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Bagian Informasi Profil
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller
                              .refreshProfile(); // Memanggil fungsi refresh
                        },
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            final user = controller.profile.value;
                            return ListView(
                              padding: const EdgeInsets.all(16.0),
                              children: [
                                _buildProfileField(
                                  "Nama",
                                  controller.usernameController.value,
                                  controller.isEditMode.value,
                                ),
                                _buildProfileField(
                                  "No. Handphone",
                                  controller.noHandphoneController.value,
                                  controller.isEditMode.value,
                                ),
                                _buildProfileField(
                                  "Alamat",
                                  controller.alamatController.value,
                                  controller.isEditMode.value,
                                ),
                                if (user != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            "Email",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            user.auth?.email ?? '-',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }
                        }),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation Bar
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin logout?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      PromptUtils.showLoading();

                      final result = await controller.logout();

                      PromptUtils.hideLoading();

                      if (result['success']) {
                        Get.offAllNamed('/login');
                      } else {
                        Get.snackbar(
                          'Logout Gagal',
                          result['message'],
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    bool isEditMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child:
                isEditMode
                    ? TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    )
                    : Text(
                      controller.text,
                      style: const TextStyle(fontSize: 16),
                    ),
          ),
        ],
      ),
    );
  }
}
