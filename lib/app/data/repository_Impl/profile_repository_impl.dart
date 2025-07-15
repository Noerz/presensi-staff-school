import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/core/const/endpoints.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'dart:io';

import 'package:presensi_school/app/data/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  ProfileRepositoryImpl({required this.client, required this.storage});

  @override
  Future<User?> getProfile() async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        Endpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        var profileData = response.data['data'];
        print(profileData);
        if (profileData != null) {
          return User.fromJson(profileData);
        } else {
          return null;
        }
      } else {
        throw Exception(response.data['message'] ?? 'Profile tidak ditemukan');
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw dioError.response?.data['message'] ?? 'Unknown server error';
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw 'Failed to load profile: $e';
    }
  }

  @override
  Future<void> updateProfilePicture(File imageFile) async {
    try {
      final token = await storage.read(key: Keys.token);
      final file = await MultipartFile.fromFile(
        imageFile.path, // path ke file di device
        filename: "profile.jpg",
      );
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({"image": file});

      final response = await client.put(
        Endpoints.changeProfilePicture,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          response.data['message'] ?? 'Failed to update profile picture',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String adress,
    required String noHp,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.put(
        Endpoints.profile,
        data: {'fullName': fullName, 'alamat': adress, 'noHp': noHp},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw dioError.response?.data['message'] ?? 'Unknown server error';
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }
}
