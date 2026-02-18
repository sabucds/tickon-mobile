import 'package:flutter/material.dart';
import '../../core/ui/tokens/app_colors.dart';
import '../../core/ui/tokens/app_colors_theme.dart';
import '../../core/ui/tokens/app_typography.dart';
import '../../core/ui/tokens/app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
        scheme: const ColorScheme.light(
          primary: AppColors.primary500,
          onPrimary: AppColors.neutral0,
          secondary: AppColors.primary300,
          onSecondary: AppColors.neutral0,
          surface: AppColors.neutral0,
          onSurface: AppColors.neutral900,
          error: AppColors.error,
          onError: AppColors.neutral0,
        ),
        scaffoldBg: AppColors.neutral50,
        colorsExtension: AppColorsTheme.light,
      );

  static ThemeData get dark => _build(
        scheme: const ColorScheme.dark(
          primary: AppColors.primary300,
          onPrimary: AppColors.neutral900,
          secondary: AppColors.primary500,
          onSecondary: AppColors.neutral0,
          surface: AppColors.neutral800,
          onSurface: AppColors.neutral0,
          error: Color(0xFFFF6B6B),
          onError: AppColors.neutral900,
        ),
        scaffoldBg: AppColors.neutral900,
        colorsExtension: AppColorsTheme.dark,
      );

  static ThemeData _build({
    required ColorScheme scheme,
    required Color scaffoldBg,
    required AppColorsTheme colorsExtension,
  }) {
    final isLight = scheme.brightness == Brightness.light;
    final borderColor = isLight ? AppColors.neutral200 : AppColors.neutral600;
    final errorColor = scheme.error;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      extensions: [colorsExtension],
      textTheme: const TextTheme(
        displayLarge:  AppTypography.displayLg,
        displaySmall:  AppTypography.displaySm,
        headlineLarge: AppTypography.headingLg,
        headlineSmall: AppTypography.headingSm,
        bodyLarge:     AppTypography.bodyLg,
        bodyMedium:    AppTypography.bodyMd,
        bodySmall:     AppTypography.bodySm,
        labelLarge:    AppTypography.labelLg,
        labelMedium:   AppTypography.labelMd,
        labelSmall:    AppTypography.labelSm,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorsExtension.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor),
        ),
        errorStyle: AppTypography.bodySm.copyWith(color: errorColor),
        helperStyle: AppTypography.bodySm,
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
    );
  }
}
