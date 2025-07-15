import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:get/get.dart';
import 'package:presensi_school/app/core/theme/app_theme.dart';
import 'package:presensi_school/app/core/utils/initial_bindings.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Presensi School",
      initialBinding: InitialBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Implementasi deteksi theme mode pada perangkat
      theme: AppTheme.lightAppTheme, // Theme untuk mode terang
      darkTheme: AppTheme.darkAppTheme, // Theme untuk mode gelap
      themeMode:
          ThemeMode.system, // Menyesuaikan dengan mode perangkat (light/dark)
    );
  }
}
