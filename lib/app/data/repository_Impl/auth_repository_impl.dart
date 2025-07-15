import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/core/const/endpoints.dart';
import 'package:presensi_school/app/data/models/user_model.dart';
import 'package:presensi_school/app/data/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({required this.client, required this.storage});

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Endpoints.login,
        data: {
          'email': username.contains('@') ? username : null,
          'nisn': username.contains('@') ? null : username,
          'password': password,
        },
      );
      print("hasil dari login : $response");
      if (response.statusCode == 200) {
        final userData =
            response.data['data']; // Ambil data di dalam objek data
        return User.fromJson(userData);
      } else {
        // Handle non-200 responses
        throw Exception(
          'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioError catch (dioError) {
      // Handle Dio errors separately for more detailed network-related errors
      if (dioError.response != null) {
        // Server responded with an error status code
        throw Exception(
          dioError.response?.data['message'] ?? 'Unknown server error',
        );
      } else {
        // No response from the server or other network errors
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      // Handle any other type of exceptions
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String nip,
    required String fullName,
    required String email,
    required String password,
    required int roleCode, // Tambahkan parameter role
  }) async {
    try {
      final response = await client.post(
        Endpoints.register,
        data: {
          'nip': nip,
          'nama': fullName,
          'email': email,
          'password': password,
          'roleCode': roleCode, // Tambahkan field role
        },
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': response.data['data']};
      } else {
        return {'success': false, 'message': response.data['data']};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Register new account failed, please try again. $e',
      };
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      final response = await client.get(
        Endpoints.profile, // Ganti dengan endpoint profile
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } on DioError catch (e) {
      // Jika unauthorized / token expired
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return false;
      }
      rethrow;
    } catch (e) {
      return false;
    }
  }
}
