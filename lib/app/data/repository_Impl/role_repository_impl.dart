import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/core/const/endpoints.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/role_model.dart';
import 'package:presensi_school/app/data/repository/role_repository.dart';

class RoleRepositoryImpl implements RoleRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  RoleRepositoryImpl({required this.client, required this.storage});

  @override
  Future<List<Role>> getRoles() async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        Endpoints.roles,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Role.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load roles: ${response.statusCode} - ${response.data['message']}',
        );
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        throw Exception(
          'Server error: ${dioError.response?.statusCode} - ${dioError.response?.data['message']}',
        );
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
