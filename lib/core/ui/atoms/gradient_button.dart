import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: _isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            gradient: _isDisabled
                ? null
                : const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            color: _isDisabled ? AppColors.neutral200 : null,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: _isDisabled
                ? null
                : [
                    BoxShadow(
                      color: AppColors.gradientStart.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: SizedBox(
            height: 56,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.neutral0,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      label,
                      style: AppTypography.labelLg.copyWith(
                        color: _isDisabled
                            ? AppColors.textDisabled
                            : AppColors.neutral0,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
