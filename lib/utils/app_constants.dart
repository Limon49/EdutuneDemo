class AppConstants {
  // App Info
  static const String appName = 'ePay Edutune';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userPhoneKey = 'user_phone';
  static const String balanceKey = 'balance';
  static const String transactionsKey = 'transactions';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';
  
  // API Constants (for future use)
  static const String baseUrl = 'https://api.epay.com';
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String transactionEndpoint = '/transactions';
  
  // Validation
  static const int minPinLength = 4;
  static const int maxPinLength = 6;
  static const int phoneNumberLength = 11;
  static const double maxTransactionAmount = 50000.0;
  static const double minTransactionAmount = 10.0;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 50.0;
  static const double inputFieldHeight = 55.0;
}
