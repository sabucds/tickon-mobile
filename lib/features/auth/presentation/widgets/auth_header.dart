import 'package:flutter/material.dart';
import '../../../../../core/ui/tokens/app_colors.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../../../../core/ui/tokens/app_typography.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              'T',
              style: AppTypography.displaySm.copyWith(
                color: AppColors.neutral0,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Tickon',
          style: AppTypography.displaySm.copyWith(
            color: AppColors.neutral800,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          subtitle,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
