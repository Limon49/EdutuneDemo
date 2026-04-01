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
  HomeScreen({super.key});

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
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          SliverToBoxAdapter(child: _buildPayBillSection(context)),
          SliverToBoxAdapter(child: _buildRemittanceSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildIcon(
    dynamic iconData, {
    Color color = AppColors.primary,
    double size = 26,
  }) {
    if (iconData is IconData) {
      return Icon(iconData, color: color, size: size);
    } else if (iconData is String) {
      return Image.asset(
        iconData,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error_outline, color: color, size: size);
        },
      );
    }
    return Icon(Icons.help_outline, color: color, size: size);
  }

  Widget _buildIconOnly(dynamic iconData, {double size = 26}) {
    if (iconData is IconData) {
      return Icon(iconData, size: size);
    } else if (iconData is String) {
      return Image.asset(
        iconData,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error_outline, size: size);
        },
      );
    }
    return Icon(Icons.help_outline, size: size);
  }

  Widget _buildSmallPrimaryButton({
    VoidCallback? onPressed,
    String text = 'See More',
  }) {
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
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.7,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 44),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.98,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'ePay Menu',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const LanguageBadge(alignment: Alignment.centerLeft),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.menuItems.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: AppColors.divider),
                      itemBuilder: (context, i) {
                        final item = controller.menuItems[i];
                        final isBold = item['bold'] as bool;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          leading: _buildIcon(
                            item['icon'],
                            color: isBold
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            size: 22,
                          ),
                          title: Text(
                            item['label'] as String,
                            style: GoogleFonts.poppins(
                              fontWeight: isBold
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                              color: isBold
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          onTap: () =>
                              controller.handleMenuItemTap(context, item),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(.7), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.accent,
                        radius: 18,
                        backgroundImage: AssetImage(controller.userAvatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
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
                ),
                const SizedBox(width: 6),
                Text(
                  '${controller.userPoints} Points',
                  style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
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
              Obx(
                () => Text(
                  controller.formattedBalance,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleBalanceVisibility,
                  child: Icon(
                    controller.getBalanceVisibilityIcon(),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 28, bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,

            runSpacing: 26,
            children: List.generate(controller.quickActions.length, (i) {
              final action = controller.quickActions[i];
              final itemWidth =
                  (MediaQuery.of(context).size.width - 36 - 22) / 4;
              return GestureDetector(
                onTap: () => controller.handleQuickActionTap(context, action),
                child: SizedBox(
                  width: itemWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Center(
            child: _buildSmallPrimaryButton(onPressed: () {}, text: 'See More'),
          ),
        ],
      ),
    );
  }

  Widget _buildPayBillSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 26,
            children: List.generate(controller.billCategories.length, (i) {
              final cat = controller.billCategories[i];
              final itemWidth =
                  (MediaQuery.of(context).size.width - 36 - 22) / 4;
              return GestureDetector(
                onTap: () => controller.handleBillCategoryTap(context, cat),
                child: SizedBox(
                  width: itemWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Center(
            child: _buildSmallPrimaryButton(onPressed: () {}, text: 'See more'),
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
                    _buildIconOnly(r['icon'], size: 26),
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
    return Obx(
      () => SizedBox(
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
                    const SizedBox(height: 64),
                    Row(
                      children: [
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
                                      : AppColors.textBlack,
                                  size: 26,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.bottomNavTabs[0]['label']
                                      as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: controller.currentTab == 0
                                        ? AppColors.primary
                                        : AppColors.textBlack,
                                    fontWeight: controller.currentTab == 0
                                        ? FontWeight.w600
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 100),

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
                                      : AppColors.textBlack,
                                  size: 26,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.bottomNavTabs[2]['label']
                                      as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: controller.currentTab == 2
                                        ? AppColors.primary
                                        : AppColors.textBlack,
                                    fontWeight: controller.currentTab == 2
                                        ? FontWeight.w600
                                        : FontWeight.w600,
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
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => controller.selectTab(1),
                  child: Container(
                    width: 56,
                    height: 56,
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
                    fontSize: 12,
                    color: controller.currentTab == 1
                        ? AppColors.primary
                        : AppColors.textBlack,
                    fontWeight: controller.currentTab == 1
                        ? FontWeight.w600
                        : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    const valleyY = 30.0;
    const notchDepth = 30.0;
    const notchHalfWidth = 45.0;
    const peakWidth = 60.0;

    final path = Path();

    // sharp top-left peak
    path.moveTo(0, peakHeight);

    // curve down from left peak to top of notch left side
    path.cubicTo(
      peakWidth,
      peakHeight,
      cx - notchHalfWidth - 60,
      valleyY,
      cx - notchHalfWidth,
      notchDepth,
    );

    // straight side down
    path.lineTo(cx - notchHalfWidth, notchDepth + 12);

    // rounded bottom only
    path.arcToPoint(
      Offset(cx + notchHalfWidth, notchDepth + 12),
      radius: const Radius.circular(12),
      clockwise: false,
    );

    // straight side back up
    path.lineTo(cx + notchHalfWidth, notchDepth);

    // curve up from notch right edge to sharp top-right peak
    path.cubicTo(
      cx + notchHalfWidth + 60,
      valleyY,
      w - peakWidth,
      peakHeight,
      w,
      peakHeight,
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
