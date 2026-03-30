import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/transaction_bloc.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const EPayApp());
}

class EPayApp extends StatelessWidget {
  const EPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<TransactionBloc>(create: (_) => TransactionBloc()),
      ],
      child: MaterialApp(
        title: 'ePay',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/welcome': (_) => const WelcomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/signup': (_) => const SignUpScreen(),
          '/otp': (_) => const OtpScreen(),
          '/home': (_) => const HomeScreen(),
          '/cashout': (_) => const CashOutScreen(),
          '/addmoney': (_) => const AddMoneyScreen(),
          '/sendmoney': (_) => const SendMoneyScreen(),
          '/confirm-cashout': (_) => const ConfirmCashOutScreen(),
          '/confirm-sendmoney': (_) => const ConfirmSendMoneyScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/statements': (_) => const StatementsScreen(),
          '/paybill': (_) => const PayBillScreen(),
          '/bill-payment': (_) => const BillPaymentScreen(),
          '/mobile-recharge': (_) => const MobileRechargeScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/points': (_) => const PointsScreen(),
          '/limits': (_) => const LimitsScreen(),
          '/coupons': (_) => const CouponsScreen(),
          '/nominee': (_) => const NomineeUpdateScreen(),
          '/info-update': (_) => const InformationUpdateScreen(),
        },
      ),
    );
  }
}
