import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../utils/app_theme.dart';
import '../utils/app_assets.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
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
  
  Widget _buildIcon(dynamic iconData, {Color color = AppColors.primary, double size = 26}) {
    if (iconData is IconData) {
      return Icon(
        iconData,
        color: color,
        size: size,
      );
    } else if (iconData is String) {
      return Image.asset(
        iconData,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.error_outline,
            color: color,
            size: size,
          );
        },
      );
    }
    return Icon(
      Icons.help_outline,
      color: color,
      size: size,
    );
  }
  
  // Helper method to render icon without background container
  Widget _buildIconOnly(dynamic iconData, {double size = 26}) {
    if (iconData is IconData) {
      return Icon(
        iconData,
        size: size,
      );
    } else if (iconData is String) {
      return Image.asset(
        iconData,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.error_outline,
            size: size,
          );
        },
      );
    }
    return Icon(
      Icons.help_outline,
      size: size,
    );
  }
  
  Widget _buildSmallPrimaryButton({VoidCallback? onPressed, String text = 'See More'}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
                itemCount: controller.menuItems.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, i) {
                  final item = controller.menuItems[i];
                  final isBold = item['bold'] as bool;
                  return ListTile(
                    leading: _buildIcon(
                      item['icon'],
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
                    onTap: () => controller.handleMenuItemTap(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                      controller.userAvatar,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    controller.userName,
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
                Image.asset(
                  AppAssets.trophyStar,
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),                const SizedBox(width: 6),
                Text(
                  '${controller.userPoints} Points',
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
              Obx(() => Text(
                controller.formattedBalance,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )),
              const SizedBox(width: 8),
              Obx(() => GestureDetector(
                onTap: controller.toggleBalanceVisibility,
                child: Icon(
                  controller.getBalanceVisibilityIcon(),
                  color: AppColors.textSecondary,
                ),
              )),
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
            itemCount: controller.quickActions.length,
            itemBuilder: (context, i) {
              final action = controller.quickActions[i];
              return GestureDetector(
                onTap: () => controller.handleQuickActionTap(context, action),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: _buildIconOnly(action['icon'], size: 26),
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
            child: _buildSmallPrimaryButton(
              onPressed: () {},
              text: 'See More',
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
            itemCount: controller.billCategories.length,
            itemBuilder: (context, i) {
              final cat = controller.billCategories[i];
              return GestureDetector(
                onTap: () => controller.handleBillCategoryTap(context, cat),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: _buildIconOnly(cat['icon'], size: 26),
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
            child: _buildSmallPrimaryButton(
              onPressed: () {},
              text: 'See more',
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
            children: controller.remittance.map((r) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: _buildIcon(
                        r['icon'],
                        color: AppColors.primary,
                        size: 26,
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
    return Obx(() => SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(double.infinity, 120),
            painter: _NotchBarPainter(),
            child: SizedBox(
              height: 120,
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Row(
                    children: [
                      // Home
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectTab(0),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIcon(
                                controller.bottomNavTabs[0]['icon'],
                                color: controller.currentTab == 0
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.bottomNavTabs[0]['label'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: controller.currentTab == 0
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: controller.currentTab == 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Center gap
                      const SizedBox(width: 100),

                      // Inbox
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectTab(2),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIcon(
                                controller.bottomNavTabs[2]['icon'],
                                color: controller.currentTab == 2
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.bottomNavTabs[2]['label'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: controller.currentTab == 2
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: controller.currentTab == 2
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating QR circle
          Positioned(
            top: 18,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => controller.selectTab(1),
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _buildIcon(
                      controller.bottomNavTabs[1]['icon'],
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // QR label
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                controller.bottomNavTabs[1]['label'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: controller.currentTab == 1
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: controller.currentTab == 1
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }}
class _NotchBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final w = size.width;
    final h = size.height;

    const peakHeight = 0.0;
    const valleyY = 40.0;
    const notchDepth = 50.0;
    const peakWidth = 80.0;
    const notchHalfWidth = 42.0;

    final path = Path();

    // sharp top-left peak
    path.moveTo(0, peakHeight);

    // curve down from left peak to notch left edge
    path.cubicTo(
      peakWidth, peakHeight,
      cx - notchHalfWidth - 70, valleyY,
      cx - notchHalfWidth, notchDepth,
    );
    // notch bottom arc
    path.arcToPoint(
      Offset(cx + notchHalfWidth, notchDepth),
      radius: const Radius.circular(10), // ← smaller radius = flatter/less circular
      clockwise: false,
    );


    // curve up from notch right edge to sharp top-right peak
    path.cubicTo(
      cx + notchHalfWidth + 60, valleyY,
      w - peakWidth, peakHeight,
      w, peakHeight,
    );

    // bottom edges
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}