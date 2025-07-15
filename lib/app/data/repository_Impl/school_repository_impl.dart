import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:presensi_school/app/core/const/endpoints.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/school_model.dart';
import 'package:presensi_school/app/data/repository/school_repository.dart';

class SchoolRepositoryImpl extends SchoolRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  SchoolRepositoryImpl({required this.client, required this.storage});

  @override
  Future<School> getSchoolById(String idSekolah) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        '${Endpoints.school}/$idSekolah',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return School.fromJson(response.data['data']);
      } else {
        throw 'Failed to load school: ${response.statusMessage}';
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to load school: $e';
    }
  }

  @override
  Future<Map<String, dynamic>> createSchool({
    required String location,
    required String inTime,
    required String outTime,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.post(
        Endpoints.school,
        data: {'location': location, 'inTime': inTime, 'outTime': outTime},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        return response.data['data'];
      } else {
        throw 'Failed to create school: ${response.statusMessage}';
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to create school: $e';
    }
  }

  @override
  Future<Map<String, dynamic>> updateSchool({
    required String idSekolah,
    required String location,
    required String inTime,
    required String outTime,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.put(
        '${Endpoints.school}/$idSekolah',
        data: {'location': location, 'inTime': inTime, 'outTime': outTime},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw 'Failed to update school: \\${response.statusMessage}';
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to update school: $e';
    }
  }

  @override
  Future<void> deleteSchool({required String idSekolah}) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.delete(
        '${Endpoints.school}/$idSekolah',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        throw 'Failed to delete school: \\${response.statusMessage}';
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to delete school: $e';
    }
  }

  @override
  Future<List<School>> getAllSchools() async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        Endpoints.school,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((e) => School.fromJson(e)).toList();
      } else {
        throw 'Failed to load schools: \\${response.statusMessage}';
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to load schools: $e';
    }
  }
}
