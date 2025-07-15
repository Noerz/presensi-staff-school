import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                icon: Obx(() => Icon(
                      controller.isEditMode.value ? Icons.check : Icons.edit,
                      color: Colors.white,
                    )),
                onPressed: () async {
                  await controller.toggleEditMode(); // Toggle edit mode
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // Radius all 8
              image: const DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                final nisn = controller.nisn.value.isNotEmpty
                    ? controller.nisn.value
                    : 'NIP tidak tersedia';
                return Text(
                  "NIP : $nisn",
                  style: const TextStyle(color: Colors.white),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
