import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:presensi_school/app/controllers/auth_controller.dart';
import 'package:presensi_school/app/data/repository/auth_repository.dart';
import 'package:presensi_school/app/data/repository/presensi_repository.dart';
import 'package:presensi_school/app/data/repository/profile_repository.dart';
import 'package:presensi_school/app/data/repository/role_repository.dart';
import 'package:presensi_school/app/data/repository/school_repository.dart';
import 'package:presensi_school/app/data/repository_Impl/auth_repository_impl.dart';
import 'package:presensi_school/app/data/repository_Impl/presensi_repository_impl.dart';
import 'package:presensi_school/app/data/repository_Impl/profile_repository_impl.dart';
import 'package:presensi_school/app/data/repository_Impl/role_repository_impl.dart';
import 'package:presensi_school/app/data/repository_Impl/school_repository_impl.dart';
import 'package:presensi_school/app/modules/export/controllers/export_controller.dart';
import 'package:presensi_school/app/modules/home/controllers/home_controller.dart';
import 'package:presensi_school/app/modules/profile/controllers/profile_controller.dart';
import 'package:presensi_school/app/modules/school/controllers/school_controller.dart';

import 'dio_utils.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Dio>(
      DioUtils.initDio(
        dotenv.env['BASE_URL'] ?? const String.fromEnvironment('BASE_URL'),
      ),
      permanent: true,
    );

    Get.put<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ),
    );

    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );
    Get.put<RoleRepository>(
      RoleRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );
    Get.put<ProfileRepository>(
      ProfileRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );
    Get.put<PresensiRepository>(
      PresensiRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );
    Get.put<SchoolRepository>(
      SchoolRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );

    // Inisialisasi controller global (injection wajib diletakkan diakhir)
    Get.put(AuthController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(SchoolController(), permanent: true);
    Get.put(ExportController(), permanent: true);
  }
}
