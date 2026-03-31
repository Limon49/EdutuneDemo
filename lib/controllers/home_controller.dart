import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/models.dart';
import 'auth_controller.dart';
import '../utils/app_assets.dart';

class HomeController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // UI State
  final selectedTab = 0.obs;
  final balanceVisible = true.obs;
  
  // User data
  final currentUser = Rxn<UserModel>();
  final currentBalance = 0.0.obs;
  
  // Quick actions data
  final List<Map<String, dynamic>> quickActions = [
    {'icon': AppAssets.group41851, 'label': 'Cash in', 'route': '/cashout'},
    {'icon': AppAssets.bank1, 'label': 'Cash Out', 'route': '/cashout'},
    {'icon': AppAssets.train, 'label': 'Add Money', 'route': '/addmoney'},
    {'icon': AppAssets.dollarCoinWithRightArrow1, 'label': 'Send Money', 'route': '/sendmoney'},
    {'icon': AppAssets.banking1, 'label': 'Mobile\nRecharge', 'route': '/mobile-recharge'},
    {'icon': AppAssets.union, 'label': 'MRT\nRecharge', 'route': '/mobile-recharge'},
    {'icon': AppAssets.union1, 'label': 'Make\nPayment', 'route': '/paybill'},
    {'icon': AppAssets.icon1, 'label': 'Express\nCard Recharge', 'route': '/mobile-recharge'},
  ];

  // Bill categories data
  final List<Map<String, dynamic>> billCategories = [
    {'icon': AppAssets.electricity1, 'label': 'Electricity'},
    {'icon': AppAssets.gasFuel1, 'label': 'Gas'},
    {'icon': AppAssets.waterTap1, 'label': 'Water'},
    {'icon': AppAssets.iconWifi, 'label': 'Internet'},
    {'icon': AppAssets.telephone1, 'label': 'Telephone'},
    {'icon': AppAssets.creditCard1, 'label': 'Credit Card'},
    {'icon': AppAssets.money1, 'label': 'Govt. Fees'},
    {'icon': AppAssets.tv, 'label': 'Cable Network'},
  ];

  // Remittance data
  final List<Map<String, dynamic>> remittance = [
    {'label': 'Payoneer', 'icon': AppAssets.symbols1},
    {'label': 'PayPal', 'icon': AppAssets.paypal},
    {'label': 'Wind', 'icon': AppAssets.image5},
    {'label': 'Wise', 'icon': AppAssets.icon2},
  ];

  // Menu items for drawer
  final List<Map<String, dynamic>> menuItems = [
    {'icon': AppAssets.home, 'label': 'Home', 'bold': false, 'route': '/home'},
    {'icon': AppAssets.user, 'label': 'Profile', 'bold': false, 'route': '/profile'},
    {'icon': AppAssets.receipt, 'label': 'Statements', 'bold': false, 'route': '/statements'},
    {'icon': AppAssets.exclamationCircle, 'label': 'Limits', 'bold': false, 'route': '/limits'},
    {'icon': AppAssets.trophyStar1, 'label': 'Coupons', 'bold': false, 'route': '/coupons'},
    {'icon': AppAssets.sackDollar, 'label': 'Points', 'bold': false, 'route': '/points'},
    {'icon': AppAssets.edit, 'label': 'Information Update', 'bold': false, 'route': '/info-update'},
    {'icon': AppAssets.settings, 'label': 'Settings', 'bold': false, 'route': '/settings'},
    {'icon': AppAssets.creditCardChange, 'label': 'Nominee Update', 'bold': false, 'route': '/nominee'},
    {'icon': AppAssets.fluentPersonSupport, 'label': 'Support', 'bold': false, 'route': null},
    {'icon': AppAssets.user, 'label': 'Refer ekPay App', 'bold': false, 'route': null},
    {'icon': AppAssets.logOut, 'label': 'Logout', 'bold': true, 'route': null},
  ];

  // Bottom nav tabs
  final List<Map<String, dynamic>> bottomNavTabs = [
    {'icon': AppAssets.home, 'label': 'Home'},
    {'icon': AppAssets.scanQr, 'label': 'QR Scan'},
    {'icon': AppAssets.envelope, 'label': 'Inbox'},
  ];

  // Getters
  bool get isBalanceVisible => balanceVisible.value;
  int get currentTab => selectedTab.value;
  UserModel? get user => currentUser.value;
  double get balance => currentBalance.value;
  String get formattedBalance => isBalanceVisible 
      ? 'Tk: ${balance.toStringAsFixed(2)}' 
      : 'Tk: ••••••';
  String get userAvatar => user?.avatarText ?? 'R';
  String get userName => user?.name ?? 'RAHUL';
  String get userPoints => user?.points.toString() ?? '1,972';

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadBalance();
  }

  void _loadUserData() {
    // Load user data from storage or use demo data
    currentUser.value = AppData.demoUser;
  }

  void _loadBalance() {
    // Load balance from storage or use demo data
    final savedBalance = _storage.read('balance');
    if (savedBalance != null) {
      currentBalance.value = savedBalance.toDouble();
    } else {
      currentBalance.value = AppData.demoUser.balance;
    }
  }

  // UI Actions
  void toggleBalanceVisibility() {
    balanceVisible.value = !balanceVisible.value;
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  // Navigation methods
  void navigateToRoute(BuildContext context, String? route) {
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  void handleMenuItemTap(BuildContext context, Map<String, dynamic> item) {
    Navigator.pop(context); // Close drawer
    
    if (item['label'] == 'Logout') {
      _logout();
    } else if (item['label'] == 'Home') {
      // Already on home, do nothing
    } else if (item['route'] != null) {
      Navigator.pushNamed(context, item['route'] as String);
    }
  }

  void handleQuickActionTap(BuildContext context, Map<String, dynamic> action) {
    if (action['route'] != null) {
      Navigator.pushNamed(context, action['route'] as String);
    }
  }

  void handleBillCategoryTap(BuildContext context, Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      '/bill-payment',
      arguments: {'category': category['label']},
    );
  }

  void _logout() {
    Get.find<AuthController>().add(LogoutRequested());
    Get.offAllNamed('/welcome');
  }

  // Utility methods
  String getBalanceText() {
    return isBalanceVisible 
        ? 'Tk: ${balance.toStringAsFixed(2)}' 
        : 'Tk: ••••••';
  }

  IconData getBalanceVisibilityIcon() {
    return isBalanceVisible 
        ? Icons.remove_red_eye_outlined 
        : Icons.visibility_off_outlined;
  }
}
