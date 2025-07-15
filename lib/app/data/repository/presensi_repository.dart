import 'package:presensi_school/app/data/models/presensi_model.dart';

abstract class PresensiRepository {
  Future<Map<String, dynamic>> createPresensiStaff({
    required String inLocation,
  });
  Future<Map<String, dynamic>> updatePresensiStaffOut({
    required String outLocation,
  });

  Future<Presensi?> getPresensiById(String idPresensi);

  Future<List<Presensi>> getPresensiByUser({int? page, int? limit});
}
