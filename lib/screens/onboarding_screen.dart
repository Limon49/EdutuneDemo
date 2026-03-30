import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Trusted by millions an\nessential part of your\nFinancial journey',
      iconBuilder: _buildTrustIcon,
    ),
    _OnboardingData(
      title: 'Pay all Bills in Bangladesh\nin hassle Free',
      iconBuilder: _buildPayIcon,
    ),
    _OnboardingData(
      title: 'Reliable and secure\nmoney transaction over\nthe world',
      iconBuilder: _buildSecureIcon,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Language badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: _currentPage == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: const [LanguageBadge()],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pages[i].iconBuilder(),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.primary.withOpacity(0.25),
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _pages[_currentPage].title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(text: 'Next', onPressed: _onNext),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/welcome'),
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final Widget Function() iconBuilder;
  _OnboardingData({required this.title, required this.iconBuilder});
}

Widget _buildTrustIcon() {
  return SizedBox(
    height: 280,
    child: CustomPaint(painter: _TrustIconPainter()),
  );
}

Widget _buildPayIcon() {
  return SizedBox(
    height: 280,
    child: CustomPaint(painter: _PayIconPainter()),
  );
}

Widget _buildSecureIcon() {
  return SizedBox(
    height: 280,
    child: CustomPaint(painter: _SecureIconPainter()),
  );
}

class _TrustIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Handshake
    final path = Path();
    // Left hand
    path.moveTo(cx - 90, cy + 20);
    path.lineTo(cx - 60, cy - 10);
    path.lineTo(cx - 20, cy - 10);

    // Right hand
    path.moveTo(cx + 90, cy + 20);
    path.lineTo(cx + 60, cy - 10);
    path.lineTo(cx + 20, cy - 10);

    // Clasp
    path.moveTo(cx - 20, cy - 10);
    path.lineTo(cx, cy + 15);
    path.lineTo(cx + 20, cy - 10);

    // Fingers
    for (int i = 0; i < 4; i++) {
      path.moveTo(cx - 15 + i * 10.0, cy + 15);
      path.lineTo(cx - 15 + i * 10.0, cy + 40);
    }

    canvas.drawPath(path, paint);

    // Shield above
    final shieldPath = Path();
    shieldPath.moveTo(cx, cy - 90);
    shieldPath.lineTo(cx + 40, cy - 70);
    shieldPath.lineTo(cx + 40, cy - 40);
    shieldPath.quadraticBezierTo(cx + 40, cy - 20, cx, cy - 15);
    shieldPath.quadraticBezierTo(cx - 40, cy - 20, cx - 40, cy - 40);
    shieldPath.lineTo(cx - 40, cy - 70);
    shieldPath.close();
    canvas.drawPath(shieldPath, paint);

    // Check in shield
    final checkPath = Path();
    checkPath.moveTo(cx - 15, cy - 52);
    checkPath.lineTo(cx - 3, cy - 40);
    checkPath.lineTo(cx + 18, cy - 65);
    canvas.drawPath(checkPath, paint);

    // Card left
    _drawRoundedRect(canvas, paint, cx - 90, cy - 20, 40, 70, 8);
    canvas.drawCircle(Offset(cx - 70, cy - 5), 8, paint);

    // Card right
    _drawRoundedRect(canvas, paint, cx + 50, cy - 20, 40, 70, 8);
    canvas.drawCircle(Offset(cx + 70, cy - 5), 8, paint);
  }

  void _drawRoundedRect(Canvas canvas, Paint paint, double x, double y,
      double w, double h, double r) {
    final rect =
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r));
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2 - 20;
    final cy = size.height / 2;

    // Card (rotated)
    canvas.save();
    canvas.translate(cx + 20, cy);
    canvas.rotate(-0.4);
    final cardRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-80, -55, 160, 110),
      const Radius.circular(16),
    );
    canvas.drawRRect(cardRect, paint);
    // Card chip
    final chipRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-20, -20, 40, 30),
      const Radius.circular(6),
    );
    canvas.drawRRect(chipRect, paint);
    // Card lines
    canvas.drawLine(
        const Offset(-60, 20), const Offset(60, 20), paint..strokeWidth = 3);
    canvas.drawLine(
        const Offset(-60, 30), const Offset(20, 30), paint..strokeWidth = 3);
    canvas.restore();

    paint.strokeWidth = 5;

    // Hand
    final handPath = Path();
    handPath.moveTo(cx - 80, cy + 60);
    handPath.lineTo(cx - 60, cy + 30);
    handPath.quadraticBezierTo(cx - 50, cy + 10, cx - 20, cy + 10);
    handPath.lineTo(cx + 30, cy + 10);
    handPath.quadraticBezierTo(cx + 50, cy + 10, cx + 50, cy + 30);
    handPath.lineTo(cx + 50, cy + 60);
    canvas.drawPath(handPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SecureIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Shield
    final shieldPath = Path();
    shieldPath.moveTo(cx - 55, cy - 30);
    shieldPath.lineTo(cx - 55, cy + 10);
    shieldPath.quadraticBezierTo(cx - 55, cy + 50, cx, cy + 70);
    shieldPath.quadraticBezierTo(cx + 55, cy + 50, cx + 55, cy + 10);
    shieldPath.lineTo(cx + 55, cy - 30);
    shieldPath.quadraticBezierTo(cx, cy - 80, cx - 55, cy - 30);
    canvas.drawPath(shieldPath, paint);

    // Inner circle with check
    canvas.drawCircle(Offset(cx, cy + 10), 28, paint);
    final checkPath = Path();
    checkPath.moveTo(cx - 14, cy + 10);
    checkPath.lineTo(cx - 4, cy + 20);
    checkPath.lineTo(cx + 16, cy - 5);
    canvas.drawPath(checkPath, paint);

    // Phone
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + 40, cy - 85, 65, 120),
      const Radius.circular(14),
    );
    canvas.drawRRect(phoneRect, paint);
    canvas.drawLine(
        Offset(cx + 55, cy - 75), Offset(cx + 90, cy - 75), paint);
    canvas.drawCircle(Offset(cx + 72, cy + 25), 7, paint);

    // Plus sign
    canvas.drawLine(Offset(cx - 10, cy - 65), Offset(cx - 10, cy - 40), paint);
    canvas.drawLine(Offset(cx - 22, cy - 53), Offset(cx + 2, cy - 53), paint);

    // Dots arc
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final angle = -1.8 + i * 0.25;
      final r = 85.0;
      canvas.drawCircle(
        Offset(cx - 60 + r * 0.3 * i, cy - 80 + 10.0 * i),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
