import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/auth_controller.dart';
import 'controllers/transaction_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/cashout_screen.dart';
import 'screens/transaction_screens.dart';
import 'screens/add_money_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/statements_screen.dart';
import 'screens/paybill_screen.dart';
import 'screens/mobile_recharge_screen.dart';
import 'screens/settings_extras_screens.dart';
import 'screens/nominee_info_screens.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  initializeControllers(); // Initialize GetX controllers
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EPayApp());
}

void initializeControllers() {
  Get.put(AuthController());
  Get.put(TransactionController());
}

class EPayApp extends StatelessWidget {
  const EPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ePay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/otp', page: () => const OtpScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/cashout', page: () => const CashOutScreen()),
        GetPage(name: '/addmoney', page: () => const AddMoneyScreen()),
        GetPage(name: '/sendmoney', page: () => const SendMoneyScreen()),
        GetPage(name: '/confirm-cashout', page: () => const ConfirmCashOutScreen()),
        GetPage(name: '/confirm-sendmoney', page: () => const ConfirmSendMoneyScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/statements', page: () => const StatementsScreen()),
        GetPage(name: '/paybill', page: () => const PayBillScreen()),
        GetPage(name: '/bill-payment', page: () => const BillPaymentScreen()),
        GetPage(name: '/mobile-recharge', page: () => const MobileRechargeScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
        GetPage(name: '/points', page: () => const PointsScreen()),
        GetPage(name: '/limits', page: () => const LimitsScreen()),
        GetPage(name: '/coupons', page: () => const CouponsScreen()),
        GetPage(name: '/nominee', page: () => const NomineeUpdateScreen()),
        GetPage(name: '/info-update', page: () => const InformationUpdateScreen()),
      ],
    );
  }
}
