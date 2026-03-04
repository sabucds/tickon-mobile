import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/ui/tokens/app_colors.dart';
import '../../../../core/ui/tokens/app_typography.dart';
import '../../../../core/ui/tokens/app_spacing.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotController;
  int _activeDot = 0;
  Timer? _dotTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Cycle loading dots
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _activeDot = (_activeDot + 1) % 3);
    });

    // Navigate after 2.5s
    _navTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    _dotTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            const _DecorativeCircles(),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  // Logo
                  _Logo(),
                  const SizedBox(height: AppSpacing.x3),
                  // App name
                  Text(
                    'Tickon',
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.neutral0,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  // Tagline
                  Text(
                    'Your events. Your way.',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.neutral0.withValues(alpha: 0.75),
                    ),
                  ),
                  const Spacer(flex: 4),
                  // Loading dots
                  _LoadingDots(activeDot: _activeDot),
                  const SizedBox(height: AppSpacing.x8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.neutral0.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.neutral0.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'T',
          style: AppTypography.displayLg.copyWith(
            color: AppColors.neutral0,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.activeDot});

  final int activeDot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == activeDot;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.neutral0
                .withValues(alpha: isActive ? 1.0 : 0.35),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        );
      }),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        // Top-right large circle
        Positioned(
          top: -size.width * 0.25,
          right: -size.width * 0.2,
          child: _Circle(diameter: size.width * 0.7),
        ),
        // Bottom-left medium circle
        Positioned(
          bottom: -size.width * 0.2,
          left: -size.width * 0.15,
          child: _Circle(diameter: size.width * 0.55),
        ),
        // Center-right small circle
        Positioned(
          top: size.height * 0.4,
          right: -size.width * 0.1,
          child: _Circle(diameter: size.width * 0.3),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.neutral0.withValues(alpha: 0.06),
      ),
    );
  }
}
