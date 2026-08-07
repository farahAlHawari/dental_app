import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/onboarding/presentation/widgets/on_boarding_card.dart';
import 'package:dental_app/features/onboarding/presentation/widgets/on_boarding_dot_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

 
  final List<String> lottieAssets = [
    'assets/animations/11.json',
    'assets/animations/22.json',
    'assets/animations/33.json',
  ];

final List<String> titles = [
  'Book Your Dental\nAppointment with Ease',
  'Your Complete\nDental Records',
  'Stay Connected\nwith Your Clinic',
];

final List<String> descriptions = [
  'Choose a convenient date and time, then confirm your appointment in just a few steps.',
  'Access your treatment plans, X-rays, prescriptions, and visit history anytime.',
  'Receive appointment reminders, treatment updates, and important notifications so you never miss a visit.',
];

  bool get _isLastPage => _currentIndex == titles.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishMarketingOnboarding() async {
    await SharedPrefs.setHasSeenOnboarding(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _goToNextPage() {
    if (_isLastPage) {
      _finishMarketingOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    _pageController.animateToPage(
      titles.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest, 
      
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: titles.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double pageOffset = 0;
                      if (_pageController.position.haveDimensions) {
                        pageOffset = (_pageController.page ?? _currentIndex.toDouble()) - index;
                      } else {
                        pageOffset = (_currentIndex - index).toDouble();
                      }

                      final scale = (1 - (pageOffset.abs() * 0.15)).clamp(0.85, 1.0);
                      final opacity = (1 - (pageOffset.abs() * 0.5)).clamp(0.4, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: OnboardingPageCard(
                        lottieAsset: lottieAssets[index],
                        title: titles[index].tr(),
                        description: descriptions[index].tr(),
                      ),
                    ),
                  );
                },
              ),
            ),

            OnboardingDotIndicator(
              pageCount: titles.length,
              currentIndex: _currentIndex,
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _isLastPage
                      ? const SizedBox(width: 60)
                      : TextButton(
                          onPressed: _skip,
                          child: Text(
                            'Skip'.tr(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                  ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      _isLastPage ? 'Get Started'.tr() : 'Next'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}