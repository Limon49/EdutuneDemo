import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/home_controller.dart';
import 'utils/app_theme.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    GetStorage.init(),
    _configureSystemUI(),
  ]);

  runApp(const EPayApp());
}

Future<void> _configureSystemUI() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

void _registerControllers() {
  Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  Get.lazyPut<TransactionController>(() => TransactionController(), fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
}

class EPayApp extends StatelessWidget {
  const EPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    _registerControllers();

    return GetMaterialApp(
      title: 'ePay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}