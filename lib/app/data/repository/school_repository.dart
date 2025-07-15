import 'package:presensi_school/app/data/models/school_model.dart';

abstract class SchoolRepository {
  Future<School> getSchoolById(String idSekolah);

  Future<Map<String, dynamic>> createSchool({
    required String location,
    required String inTime,
    required String outTime,
  });

  Future<Map<String, dynamic>> updateSchool({
    required String idSekolah,
    required String location,
    required String inTime,
    required String outTime,
  });

  Future<void> deleteSchool({required String idSekolah});

  Future<List<School>> getAllSchools();
}
