import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:presensi_school/app/core/const/endpoints.dart';
import 'package:presensi_school/app/core/const/keys.dart';
import 'package:presensi_school/app/data/models/presensi_model.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';

class PresensiRepositoryImpl extends PresensiRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  PresensiRepositoryImpl({required this.client, required this.storage});

  @override
  Future<Map<String, dynamic>> createPresensiStaff({
    required String inLocation,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.post(
        Endpoints.presensiStaff,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'inLocation': inLocation},
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message':
              response.data['message'] ?? 'Failed to create presensi staff',
        };
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        return {
          'success': false,
          'message':
              dioError.response?.data['message'] ?? 'Unknown server error',
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${dioError.message}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Create presensi staff failed, please try again. $e',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updatePresensiStaffOut({
    required String outLocation,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.put(
        Endpoints.presensiStaff,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'outLocation': outLocation},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update presensi',
        };
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        return {
          'success': false,
          'message':
              dioError.response?.data['message'] ?? 'Unknown server error',
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${dioError.message}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Update presensi failed, please try again. $e',
      };
    }
  }

  @override
  Future<Presensi?> getPresensiById(String idPresensi) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        '${Endpoints.presensi}/$idPresensi',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Presensi.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to load presensi: $e';
    }
  }

  @override
  Future<List<Presensi>> getPresensiByUser({int? page, int? limit}) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        Endpoints.getPresensiByUser,
        queryParameters: {'page': 1, 'limit': limit ?? 10},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Presensi.fromJson(json)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to retrieve presensi',
        );
      }
    } on DioError catch (dioError) {
      throw dioError.response?.data['message'] ?? 'Unknown server error';
    } catch (e) {
      throw 'Failed to load presensi: $e';
    }
  }

  @override
  Future<String?> exportPresensiToExcel({
    int? bulan,
    int? tahun,
    String? userId,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);

      final params = <String, dynamic>{};
      if (bulan != null) params['bulan'] = bulan;
      if (tahun != null) params['tahun'] = tahun;
      if (userId != null) params['userId'] = userId;

      final response = await client.get(
        Endpoints.exportRekapPresensi,
        queryParameters: params,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        // Simpan file ke device
        final fileName =
            "rekap_presensi_${bulan ?? 'all'}_${tahun ?? 'all'}.xlsx";
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.data);
        return filePath;
      }
      return null;
    } catch (e) {
      print('Download Excel error: $e');
      return null;
    }
  }
}
