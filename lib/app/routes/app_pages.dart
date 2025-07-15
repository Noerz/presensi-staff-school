import 'package:get/get.dart';

import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/presensi/bindings/presensi_binding.dart';
import '../modules/presensi/views/presensi_keluar_view.dart';
import '../modules/presensi/views/presensi_masuk_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/registrasi/bindings/registrasi_binding.dart';
import '../modules/registrasi/views/registrasi_view.dart';
import '../modules/school/bindings/school_binding.dart';
import '../modules/school/views/school_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI_MASUK,
      page: () => const PresensiMasukView(),
      binding: PresensiBinding(),
    ),
    GetPage(
      name: _Paths.PRESENSI_KELUAR,
      page: () => const PresensiKeluarView(),
      binding: PresensiBinding(),
    ),
    GetPage(
      name: _Paths.SCHOOL,
      page: () => const SchoolView(),
      binding: SchoolBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRASI,
      page: () => RegistrasiView(),
      binding: RegistrasiBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
