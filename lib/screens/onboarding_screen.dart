import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/app_theme.dart';
import '../utils/app_assets.dart';
import '../routes/app_routes.dart';
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
      imagePath: AppAssets.onboarding1,
    ),
    _OnboardingData(
      title: 'Pay all Bills in Bangladesh\nin hassle Free',
      imagePath: AppAssets.onboarding2,
    ),
    _OnboardingData(
      title: 'Reliable and secure\nmoney transaction over\nthe world',
      imagePath: AppAssets.onboarding3,
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
      AppRoutes.navigateAndReplace(AppRoutes.welcome);
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
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              _pages[i].imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback container if image not found
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    size: 80,
                                    color: AppColors.primary.withOpacity(0.5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 16,
                  height: 8,
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.primary,
                ),
                dotDecoration: DotDecoration(
                  width: 36,
                  height: 8,
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.primary.withOpacity(0.25),
                ),
                // activeDotColor: AppColors.primary,
                // dotColor: AppColors.primary.withOpacity(0.25),
                // dotHeight: 8,
                // dotWidth: 18,
                // expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _pages[_currentPage].title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(text: 'Next', onPressed: _onNext),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => AppRoutes.navigateAndReplace(AppRoutes.welcome),
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
  final String imagePath;
  _OnboardingData({required this.title, required this.imagePath});
}
