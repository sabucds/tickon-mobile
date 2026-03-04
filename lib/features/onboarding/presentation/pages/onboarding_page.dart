import 'package:flutter/material.dart';
import '../../../../core/ui/tokens/app_colors.dart';
import '../../../../core/ui/tokens/app_typography.dart';
import '../../../../core/ui/tokens/app_spacing.dart';
import '../../../../core/ui/atoms/gradient_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      emoji: '🎉',
      title: 'Discover Amazing Events',
      description:
          'From concerts to sports — find what excites you, happening near you.',
    ),
    _OnboardingData(
      emoji: '⚡',
      title: 'Book in Seconds, Not Minutes',
      description:
          'Choose your seats, pay securely, get your ticket instantly.',
    ),
    _OnboardingData(
      emoji: '🎟️',
      title: 'Your Tickets, Always with You',
      description:
          'Access all your tickets offline. No printing, no hassle.',
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _next() {
    if (_isLastPage) {
      _goToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.x4,
                  right: AppSpacing.x6,
                ),
                child: GestureDetector(
                  onTap: _goToLogin,
                  child: Text(
                    'Skip',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardingSlide(data: _pages[i]),
              ),
            ),
            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x4,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              child: Column(
                children: [
                  _PageDots(
                    count: _pages.length,
                    current: _currentPage,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  GradientButton(
                    key: const Key('onboarding_cta'),
                    label: _isLastPage ? 'Get Started' : 'Next',
                    onPressed: _next,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          _Illustration(emoji: data.emoji),
          const SizedBox(height: AppSpacing.x8),
          // Title
          Text(
            data.title,
            style: AppTypography.displaySm.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x4),
          // Description
          Text(
            data.description,
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.gradientStart.withValues(alpha: 0.12),
            AppColors.gradientEnd.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientStart.withValues(alpha: 0.2),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 96),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: isActive
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  color: AppColors.neutral200,
                ),
        );
      }),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.description,
  });

  final String emoji;
  final String title;
  final String description;
}
