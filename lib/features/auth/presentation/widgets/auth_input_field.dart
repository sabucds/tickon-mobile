import 'package:flutter/material.dart';
import '../../../../../core/ui/tokens/app_colors.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../../../../core/ui/tokens/app_typography.dart';

/// Figma-styled input: uppercase label above + filled container with border.
class AuthInputField extends StatefulWidget {
  const AuthInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final Widget? suffix;

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: widget.errorText != null ? AppColors.error : AppColors.border,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            enabled: widget.enabled,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            style: AppTypography.bodyLg.copyWith(
              color: widget.enabled ? AppColors.onSurface : AppColors.textDisabled,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.textDisabled),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              isDense: true,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textDisabled,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscured = !_obscured),
                    )
                  : widget.suffix,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            widget.errorText!,
            style: AppTypography.bodySm.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
