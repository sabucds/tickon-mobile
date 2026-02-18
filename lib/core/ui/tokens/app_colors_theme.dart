import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ThemeExtension that holds semantic color slots for both light and dark.
/// Atoms read colors from here via [BuildContext.appColors] instead of
/// using raw [AppColors] constants, so brightness changes are automatic.
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.inputFill,
    required this.inputFillDisabled,
    required this.secondaryButtonBg,
    required this.secondaryButtonFg,
  });

  final Color background;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color inputFill;
  final Color inputFillDisabled;
  final Color secondaryButtonBg;
  final Color secondaryButtonFg;

  static const light = AppColorsTheme(
    background:          AppColors.neutral50,
    surface:             AppColors.neutral0,
    border:              AppColors.neutral200,
    textPrimary:         AppColors.neutral900,
    textSecondary:       AppColors.neutral600,
    textDisabled:        AppColors.neutral400,
    inputFill:           AppColors.neutral0,
    inputFillDisabled:   AppColors.neutral100,
    secondaryButtonBg:   AppColors.primary100,
    secondaryButtonFg:   AppColors.primary700,
  );

  static const dark = AppColorsTheme(
    background:          AppColors.neutral900,
    surface:             AppColors.neutral800,
    border:              AppColors.neutral600,
    textPrimary:         AppColors.neutral0,
    textSecondary:       AppColors.neutral400,
    textDisabled:        AppColors.neutral600,
    inputFill:           AppColors.neutral800,
    inputFillDisabled:   AppColors.neutral900,
    secondaryButtonBg:   AppColors.primary900,
    secondaryButtonFg:   AppColors.primary300,
  );

  @override
  AppColorsTheme copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? inputFill,
    Color? inputFillDisabled,
    Color? secondaryButtonBg,
    Color? secondaryButtonFg,
  }) =>
      AppColorsTheme(
        background:        background        ?? this.background,
        surface:           surface           ?? this.surface,
        border:            border            ?? this.border,
        textPrimary:       textPrimary       ?? this.textPrimary,
        textSecondary:     textSecondary     ?? this.textSecondary,
        textDisabled:      textDisabled      ?? this.textDisabled,
        inputFill:         inputFill         ?? this.inputFill,
        inputFillDisabled: inputFillDisabled ?? this.inputFillDisabled,
        secondaryButtonBg: secondaryButtonBg ?? this.secondaryButtonBg,
        secondaryButtonFg: secondaryButtonFg ?? this.secondaryButtonFg,
      );

  @override
  AppColorsTheme lerp(AppColorsTheme? other, double t) {
    if (other == null) return this;
    return AppColorsTheme(
      background:        Color.lerp(background,        other.background,        t)!,
      surface:           Color.lerp(surface,           other.surface,           t)!,
      border:            Color.lerp(border,            other.border,            t)!,
      textPrimary:       Color.lerp(textPrimary,       other.textPrimary,       t)!,
      textSecondary:     Color.lerp(textSecondary,     other.textSecondary,     t)!,
      textDisabled:      Color.lerp(textDisabled,      other.textDisabled,      t)!,
      inputFill:         Color.lerp(inputFill,         other.inputFill,         t)!,
      inputFillDisabled: Color.lerp(inputFillDisabled, other.inputFillDisabled, t)!,
      secondaryButtonBg: Color.lerp(secondaryButtonBg, other.secondaryButtonBg, t)!,
      secondaryButtonFg: Color.lerp(secondaryButtonFg, other.secondaryButtonFg, t)!,
    );
  }
}

extension AppColorsThemeX on BuildContext {
  AppColorsTheme get appColors =>
      Theme.of(this).extension<AppColorsTheme>()!;
}
