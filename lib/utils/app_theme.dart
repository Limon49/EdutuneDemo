import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF003780);
  static const Color primaryLight = Color(0xFF2D5BA3);
  static const Color accent = Color(0xFFF5A623);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF0F4F8);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textBlack = Color(0xFF101010);
  static const Color black400 = Color(0xFF404040);

  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color cardBg = Color(0xFFF8FAFC);
  static const Color langBadge = Color(0xFFFFF0D4);
  static const Color confirmDisabled = Color(0xFFB0BEC5);
  static const Color inputBg = Color(0xFFEEF2F7);
  static const Color buttonGrey = Color(0xFFB0C1D8);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AppStrings {
  static const String appName = 'ePay';
  static const String trustedByMillions =
      'Trusted by millions an essential part of your Financial journey';
  static const String payBills =
      'Pay all Bills in Bangladesh in hassle Free';
  static const String reliableSecure =
      'Reliable and secure money transaction over the world';
  static const String logIn = 'Log in Epay';
  static const String createAccount = 'Create Your Epay Account';
  static const String signUp = 'Sign Up';
  static const String login = 'Log In';
  static const String phoneNumber = 'Phone Number';
  static const String enterPin = 'Enter 6 Digit PIN';
  static const String forgotPin = 'Forgot PIN ?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String didYouFaceIssue = 'Did you face any issue?';
  static const String contactUs = 'Contact Us';
  static const String bangla = 'বাংলা';
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String yourBalance = 'Your Balance';
  static const String cashIn = 'Cash in';
  static const String cashOut = 'Cash Out';
  static const String addMoney = 'Add Money';
  static const String sendMoney = 'Send Money';
  static const String payBill = 'Pay Bill';
  static const String mobileRecharge = 'Mobile\nRecharge';
  static const String mrtRecharge = 'MRT\nRecharge';
  static const String makePayment = 'Make\nPayment';
  static const String seeMore = 'See More';
  static const String expressCardRecharge = 'Express\nCard Recharge';
  static const String remittance = 'Remittance';
  static const String home = 'Home';
  static const String qrScan = 'QR Scan';
  static const String inbox = 'Inbox';
  static const String confirm = 'Confirm';
  static const String backToHome = 'Back To Home';
}
