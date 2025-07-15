import 'dart:io';

import 'package:presensi_school/app/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<User?> getProfile();

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String adress,
    required String noHp,
    
  });

  // // Mendapatkan URL gambar profil
  // Future<String> getProfilePicture();

  // Mengupdate gambar profil
  Future<void> updateProfilePicture(File imageFile);
}
