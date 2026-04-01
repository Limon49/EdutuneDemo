import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screens.dart';
import '../screens/home_screen.dart';
import '../screens/cashout_screen.dart';
import '../screens/transaction_screens.dart';
import '../screens/add_money_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/statements_screen.dart';
import '../screens/paybill_screen.dart';
import '../screens/mobile_recharge_screen.dart';
import '../screens/settings_extras_screens.dart';
import '../screens/nominee_info_screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String cashout = '/cashout';
  static const String addmoney = '/addmoney';
  static const String sendmoney = '/sendmoney';
  static const String confirmCashout = '/confirm-cashout';
  static const String confirmSendmoney = '/confirm-sendmoney';
  static const String profile = '/profile';
  static const String statements = '/statements';
  static const String paybill = '/paybill';
  static const String billPayment = '/bill-payment';
  static const String mobileRecharge = '/mobile-recharge';
  static const String settings = '/settings';
  static const String points = '/points';
  static const String limits = '/limits';
  static const String coupons = '/coupons';
  static const String nominee = '/nominee';
  static const String infoUpdate = '/info-update';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignUpScreen()),
    GetPage(name: otp, page: () => const OtpScreen()),
    GetPage(name: home, page: () =>  HomeScreen()),
    GetPage(name: cashout, page: () => const CashOutScreen()),
    GetPage(name: addmoney, page: () => const AddMoneyScreen()),
    GetPage(name: sendmoney, page: () => const SendMoneyScreen()),
    GetPage(name: confirmCashout, page: () => const ConfirmCashOutScreen()),
    GetPage(name: confirmSendmoney, page: () => const ConfirmSendMoneyScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: statements, page: () => const StatementsScreen()),
    GetPage(name: paybill, page: () => const PayBillScreen()),
    GetPage(name: billPayment, page: () => const BillPaymentScreen()),
    GetPage(name: mobileRecharge, page: () => const MobileRechargeScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: points, page: () => const PointsScreen()),
    GetPage(name: limits, page: () => const LimitsScreen()),
    GetPage(name: coupons, page: () => const CouponsScreen()),
    GetPage(name: nominee, page: () => const NomineeUpdateScreen()),
    GetPage(name: infoUpdate, page: () => const InformationUpdateScreen()),
  ];

  // Navigation helpers
  static void navigateTo(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }

  static void navigateAndReplace(String route) {
    Get.offNamed(route);
  }

  static void navigateAndClearStack(String route) {
    Get.offAllNamed(route);
  }

  static void pop() {
    Get.back();
  }

  static void popToFirst() {
    Get.until((route) => route.isFirst);
  }
}
