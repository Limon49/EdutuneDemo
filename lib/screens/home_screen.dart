import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  bool _balanceVisible = true;

  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.arrow_downward_rounded, 'label': 'Cash in', 'route': '/cashout'},
    {'icon': Icons.arrow_upward_rounded, 'label': 'Cash Out', 'route': '/cashout'},
    {'icon': Icons.add_circle_outline, 'label': 'Add Money', 'route': '/addmoney'},
    {'icon': Icons.send_rounded, 'label': 'Send Money', 'route': '/sendmoney'},
    {'icon': Icons.phone_android, 'label': 'Mobile\nRecharge', 'route': '/mobile-recharge'},
    {'icon': Icons.train, 'label': 'MRT\nRecharge', 'route': '/mobile-recharge'},
    {'icon': Icons.payment, 'label': 'Make\nPayment', 'route': '/paybill'},
    {'icon': Icons.credit_card, 'label': 'Express\nCard Recharge', 'route': '/mobile-recharge'},
  ];

  final List<Map<String, dynamic>> _billCategories = [
    {'icon': Icons.lightbulb_outline, 'label': 'Electricity'},
    {'icon': Icons.local_fire_department_outlined, 'label': 'Gas'},
    {'icon': Icons.water_drop_outlined, 'label': 'Water'},
    {'icon': Icons.wifi, 'label': 'Internet'},
    {'icon': Icons.phone, 'label': 'Telephone'},
    {'icon': Icons.credit_card, 'label': 'Credit Card'},
    {'icon': Icons.account_balance, 'label': 'Govt. Fees'},
    {'icon': Icons.tv, 'label': 'Cable Network'},
  ];

  final List<Map<String, dynamic>> _remittance = [
    {'label': 'Payoneer', 'color': Colors.orange},
    {'label': 'PayPal', 'color': Colors.blue},
    {'label': 'Wind', 'color': Colors.purple},
    {'label': 'Wise', 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildBalanceCard()),
          SliverToBoxAdapter(child: _buildQuickActions()),
          SliverToBoxAdapter(child: _buildPayBillSection()),
          SliverToBoxAdapter(child: _buildRemittanceSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final menuItems = [
      {'icon': Icons.home_outlined, 'label': 'Home', 'bold': false, 'route': '/home'},
      {'icon': Icons.person_outline, 'label': 'Profile', 'bold': false, 'route': '/profile'},
      {'icon': Icons.receipt_outlined, 'label': 'Statements', 'bold': false, 'route': '/statements'},
      {'icon': Icons.info_outline, 'label': 'Limits', 'bold': false, 'route': '/limits'},
      {'icon': Icons.local_offer_outlined, 'label': 'Coupons', 'bold': false, 'route': '/coupons'},
      {'icon': Icons.emoji_events_outlined, 'label': 'Points', 'bold': false, 'route': '/points'},
      {'icon': Icons.edit_outlined, 'label': 'Information Update', 'bold': false, 'route': '/info-update'},
      {'icon': Icons.settings_outlined, 'label': 'Settings', 'bold': false, 'route': '/settings'},
      {'icon': Icons.person_add_outlined, 'label': 'Nominee Update', 'bold': false, 'route': '/nominee'},
      {'icon': Icons.support_agent_outlined, 'label': 'Support', 'bold': false, 'route': null},
      {'icon': Icons.share_outlined, 'label': 'Refer ekPay App', 'bold': false, 'route': null},
      {'icon': Icons.logout, 'label': 'Logout', 'bold': true, 'route': null},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ePay Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const LanguageBadge(),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, i) {
                  final item = menuItems[i];
                  final isBold = item['bold'] as bool;
                  return ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isBold ? AppColors.primary : AppColors.textPrimary,
                      size: 22,
                    ),
                    title: Text(
                      item['label'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight:
                            isBold ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                        color: isBold
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (item['label'] == 'Logout') {
                        context.read<AuthBloc>().add(LogoutRequested());
                        Navigator.pushReplacementNamed(context, '/welcome');
                      } else if (item['label'] == 'Home') {
                        // already on home
                      } else if (item['route'] != null) {
                        Navigator.pushNamed(context, item['route'] as String);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.accent,
                    radius: 18,
                    child: Text(
                      'R',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'RAHUL',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '1,972 Points',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            'Your Balance',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _balanceVisible ? 'Tk: 13,999.00' : 'Tk: ••••••',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    setState(() => _balanceVisible = !_balanceVisible),
                child: Icon(
                  _balanceVisible
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
            ),
            itemCount: 8,
            itemBuilder: (context, i) {
              final action = _quickActions[i];
              return GestureDetector(
                onTap: () {
                  if (action['route'] != null) {
                    Navigator.pushNamed(context, action['route'] as String);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      action['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text(
                'See More',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayBillSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pay Bill',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
            ),
            itemCount: _billCategories.length,
            itemBuilder: (context, i) {
              final cat = _billCategories[i];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/bill-payment',
                  arguments: {'category': cat['label']},
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text(
                'See more',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemittanceSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remittance',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: _remittance.map((r) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (r['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          (r['label'] as String)[0],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: r['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      r['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final tabs = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.qr_code_scanner, 'label': 'QR Scan'},
      {'icon': Icons.inbox, 'label': 'Inbox'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final isMiddle = i == 1;
              final isSelected = _selectedTab == i;
              if (isMiddle) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            tabs[i]['icon'] as IconData,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tabs[i]['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 26,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tabs[i]['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
