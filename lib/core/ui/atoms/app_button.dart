import 'package:flutter/material.dart';
import '../tokens/app_colors_theme.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined, ghost }

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? leading;

  bool get _isDisabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final style = _resolveStyle(colors, scheme);
    final content = _buildContent(colors, scheme);

    Widget button = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.secondary => ElevatedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: style,
          child: content,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: _isDisabled ? null : onPressed,
          style: style,
          child: content,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: _isDisabled ? null : onPressed,
          style: style,
          child: content,
        ),
    };

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildContent(AppColorsTheme colors, ColorScheme scheme) {
    if (isLoading) {
      return SizedBox(
        width: _loaderSize,
        height: _loaderSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _loaderColor(colors, scheme),
        ),
      );
    }

    if (leading != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading!,
          const SizedBox(width: AppSpacing.x2),
          Text(label),
        ],
      );
    }

    return Text(label);
  }

  double get _loaderSize => switch (size) {
        AppButtonSize.sm => 14,
        AppButtonSize.md => 16,
        AppButtonSize.lg => 18,
      };

  Color _loaderColor(AppColorsTheme colors, ColorScheme scheme) =>
      switch (variant) {
        AppButtonVariant.primary => scheme.onPrimary,
        AppButtonVariant.secondary => colors.secondaryButtonFg,
        AppButtonVariant.outlined || AppButtonVariant.ghost => scheme.primary,
      };

  ButtonStyle _resolveStyle(AppColorsTheme colors, ColorScheme scheme) {
    final (bg, fg, borderColor) = _resolveColors(colors, scheme);
    final padding = _resolvePadding();
    final textStyle = _resolveTextStyle();

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.border;
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.textDisabled;
        }
        return fg;
      }),
      overlayColor: WidgetStateProperty.all(fg?.withValues(alpha: 0.08)),
      side: borderColor != null
          ? WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: colors.border);
              }
              return BorderSide(color: borderColor);
            })
          : null,
      padding: WidgetStateProperty.all(padding),
      textStyle: WidgetStateProperty.all(textStyle),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      elevation: WidgetStateProperty.all(0),
      minimumSize: WidgetStateProperty.all(Size(0, _minHeight)),
    );
  }

  (Color?, Color?, Color?) _resolveColors(
    AppColorsTheme colors,
    ColorScheme scheme,
  ) =>
      switch (variant) {
        AppButtonVariant.primary => (
            scheme.primary,
            scheme.onPrimary,
            null,
          ),
        AppButtonVariant.secondary => (
            colors.secondaryButtonBg,
            colors.secondaryButtonFg,
            null,
          ),
        AppButtonVariant.outlined => (
            Colors.transparent,
            scheme.primary,
            scheme.primary,
          ),
        AppButtonVariant.ghost => (
            Colors.transparent,
            scheme.primary,
            null,
          ),
      };

  EdgeInsets _resolvePadding() => switch (size) {
        AppButtonSize.sm => const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
        AppButtonSize.md => const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
        AppButtonSize.lg => const EdgeInsets.symmetric(
            horizontal: AppSpacing.x6,
            vertical: AppSpacing.x4,
          ),
      };

  TextStyle _resolveTextStyle() => switch (size) {
        AppButtonSize.sm => AppTypography.labelSm,
        AppButtonSize.md => AppTypography.labelMd,
        AppButtonSize.lg => AppTypography.labelLg,
      };

  double get _minHeight => switch (size) {
        AppButtonSize.sm => 32,
        AppButtonSize.md => 44,
        AppButtonSize.lg => 52,
      };
}

