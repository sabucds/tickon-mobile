# Plan: Core UI scaffold (tokens + AppButton)

## Goal
Bootstrap `lib/core/ui/` with design tokens and a reference atom (`AppButton`) following the shadcn/own-your-code philosophy.

## Files to create
- `lib/core/ui/tokens/app_colors.dart` — color palette + semantic aliases
- `lib/core/ui/tokens/app_typography.dart` — text style scale
- `lib/core/ui/tokens/app_spacing.dart` — spacing constants
- `lib/app/theme/app_theme.dart` — assembles Flutter `ThemeData` from tokens
- `lib/core/ui/atoms/app_button.dart` — button atom (variants + sizes + loading)

## Files to update
- `lib/main.dart` — remove boilerplate, wire `AppTheme`

## Files to create (tests)
- `test/core/ui/atoms/app_button_test.dart`

## Test plan
- AppButton renders label
- AppButton calls onPressed when tapped
- AppButton shows loading indicator when isLoading=true
- AppButton does not fire onPressed when isLoading=true
- AppButton does not fire onPressed when disabled (onPressed=null)

## Rollback
Delete `lib/core/ui/`, `lib/app/theme/`, revert `main.dart`.
