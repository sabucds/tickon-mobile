# Figma MCP Integration — Design System Rules

Figma file: **xFOXoRhMFaGNeXi8raLuvc** (`https://www.figma.com/design/xFOXoRhMFaGNeXi8raLuvc/Tickon`)

---

## Required Flow (never skip)

When implementing designs from Figma:

1. **Get design context** — `get_design_context(fileKey, nodeId)` for structure + reference code
2. **Get screenshot** — `get_screenshot(fileKey, nodeId)` for exact visual reference
3. **Download assets** — use localhost URLs from Figma MCP directly; never create placeholders
4. **Translate to Flutter** — convert React + Tailwind reference to Flutter using project tokens and atoms
5. **Validate** — compare against the screenshot for 1:1 visual parity before marking complete

---

## Design Token System

### Colors — `lib/core/ui/tokens/app_colors.dart`

IMPORTANT: **Never hardcode hex values.** Always use `AppColors` constants.

| Constant | Value | Usage |
|---|---|---|
| `primary100` – `primary900` | Purple shades | Brand primary palette |
| `neutral0` – `neutral900` | White → near-black | Backgrounds, text, borders |
| `gradientStart` | `#667EEA` | Gradient / accent (left/top) |
| `gradientEnd` | `#764BA2` | Gradient / accent (right/bottom) |
| `success` | Green | Positive feedback |
| `error` | Red | Errors, destructive |
| `warning` | Amber | Warnings |
| `surface` | Light background | Card / screen backgrounds |
| `onSurface` | Near-black | Primary text on surface |
| `border` | Light grey | Input/card borders |
| `textPrimary` | Dark | Primary labels |
| `textSecondary` | Medium grey | Secondary labels |
| `textDisabled` | Light grey | Disabled text / hints |
| `neutral50` | Off-white | Input fill backgrounds |

**Theme-aware colors** — use `context.appColors` (ThemeExtension) or `Theme.of(context).colorScheme`:

```dart
// Good
Container(color: AppColors.primary500)
Text('hello', style: TextStyle(color: context.appColors.textPrimary))

// Bad
Container(color: Color(0xFF7C3AED))
Container(color: Color(0xFF667EEA))
```

**Brand gradient** — always use `gradientStart → gradientEnd`:

```dart
LinearGradient(
  colors: [AppColors.gradientStart, AppColors.gradientEnd],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

---

### Typography — `lib/core/ui/tokens/app_typography.dart`

IMPORTANT: **Never write inline `TextStyle`.** Always use `AppTypography` constants.

| Constant | Size | Weight | Usage |
|---|---|---|---|
| `displayLg` | 36px | 700 | Hero titles |
| `displaySm` | 28px | 700 | Page titles |
| `headingLg` | 22px | 600 | Section headings |
| `headingSm` | 18px | 600 | Sub-headings |
| `bodyLg` | 16px | 400 | Primary body / input text |
| `bodyMd` | 14px | 400 | Secondary body |
| `bodySm` | 12px | 400 | Captions, error messages |
| `labelLg` | 16px | 600 | Button labels (large) |
| `labelMd` | 14px | 600 | Button labels / tags |
| `labelSm` | 12px | 600 | Input labels (uppercased) |

All styles are color-agnostic — add color via `.copyWith(color: ...)` or the theme.

```dart
// Good
Text('Discover Events', style: AppTypography.headingLg)
Text('ERROR', style: AppTypography.labelSm.copyWith(color: AppColors.error))

// Bad
Text('Discover Events', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
```

---

### Spacing & Radius — `lib/core/ui/tokens/app_spacing.dart`

IMPORTANT: **Use spacing constants — no magic numbers.**

**AppSpacing** (4px base scale):

| Constant | Value |
|---|---|
| `x1` | 4px |
| `x2` | 8px |
| `x3` | 12px |
| `x4` | 16px |
| `x6` | 24px |
| `x8` | 32px |
| `x12` | 48px |
| `x16` | 64px |

**AppRadius:**

| Constant | Value |
|---|---|
| `sm` | 6px |
| `md` | 10px |
| `lg` | 16px |
| `full` | 999px |

```dart
// Good
SizedBox(height: AppSpacing.x4)
Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.x6))
BorderRadius.circular(AppRadius.md)

// Bad
SizedBox(height: 16)
BorderRadius.circular(10)
```

---

## Component Library

### Atom Inventory — `lib/core/ui/atoms/`

IMPORTANT: **Always check this directory before creating any new UI primitive.** Reuse first.

#### `AppButton` — `lib/core/ui/atoms/app_button.dart`

General-purpose button with full variant + size support.

- **Variants**: `primary`, `secondary`, `outlined`, `ghost`
- **Sizes**: `sm`, `md`, `lg`
- **States**: loading (spinner replaces label), disabled, full-width, leading icon

```dart
AppButton(
  label: 'Sign In',
  variant: AppButtonVariant.primary,
  size: AppButtonSize.lg,
  onPressed: _submit,
  isLoading: isLoading,
  isFullWidth: true,
)
```

#### `GradientButton` — `lib/core/ui/atoms/gradient_button.dart`

Branded gradient CTA button. Use for primary actions on auth/onboarding screens.

- Gradient: `gradientStart → gradientEnd` (170°)
- Shadow: `rgba(102,126,234,0.35)` blur 12
- Radius: `AppRadius.lg` (16px)
- Height: 56px
- Loading state: `CircularProgressIndicator.adaptive` (white)

```dart
GradientButton(
  label: 'Create Account',
  onPressed: isLoading ? null : _submit,
  isLoading: isLoading,
  isFullWidth: true,
)
```

Use `GradientButton` (not `AppButton`) when the design calls for the brand purple gradient.

#### `AppTextField` — `lib/core/ui/atoms/app_text_field.dart`

Standard Material-styled text input. Supports label, hint, error, obscure toggle, leading/trailing icons.

---

### Feature Widgets — `lib/features/<feature>/presentation/widgets/`

Feature-specific, non-reusable components live here. Current notable widgets:

#### `AuthInputField` — `lib/features/auth/presentation/widgets/auth_input_field.dart`

Figma-styled auth input: uppercase label above + filled `neutral50` container with 1.5px border.

- Error state: border switches to `AppColors.error`
- Password toggle: auto-rendered when `obscureText: true`
- Height: 54px container

```dart
AuthInputField(
  label: 'Email',
  controller: _emailController,
  hint: 'your.email@example.com',
  errorText: _emailError,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
)
```

Use `AuthInputField` for all auth/onboarding forms. Use `AppTextField` for general in-app forms.

#### `AuthHeader` — `lib/features/auth/presentation/widgets/auth_header.dart`

Gradient "T" logo (72×72, radius 20) + "Tickon" title + dynamic subtitle.

```dart
AuthHeader(subtitle: 'Welcome back')
AuthHeader(subtitle: 'Create your account')
```

---

## Screen Patterns

### Splash Screen

- Full-screen gradient background: `gradientStart → gradientEnd` (160°)
- Decorative translucent circles (rgba white 6%)
- Logo: white frosted glass square, "T" text 48px bold
- App name: 36px bold white
- Tagline: 16px rgba(white, 75%)
- Loading dots at bottom (active dot wider pill shape)

### Onboarding Screens

- White background, status bar top
- "Skip" link top-right (`textSecondary`)
- Illustration: 280×280 circular pale gradient bg + 96px emoji icon with drop shadow
- Title: `AppTypography.displaySm` centered
- Description: `AppTypography.bodyLg` centered, `textSecondary`
- Bottom: progress dots + `GradientButton` ("Next" / "Get Started")
- Dot indicator: inactive = `neutral200` 8px circle; active = gradient pill 24×8px

### Auth Screens (Login / Register)

- White `AppColors.surface` background
- `SafeArea` + `SingleChildScrollView`
- Horizontal padding: `AppSpacing.x6`
- Top/bottom padding: `AppSpacing.x8`
- `AuthHeader` at top
- `AuthInputField` for all form fields
- `GradientButton` for primary CTA
- `textSecondary` for helper text; `gradientStart` for links

---

## Architecture Patterns (Clean Architecture)

- **Features**: `lib/features/<feature>/` — organized by domain
  - `data/` — API models, repository impls, data sources
  - `domain/` — entities, use cases, repository interfaces, failures
  - `presentation/` — pages, widgets, cubits/blocs
- **State management**: `flutter_bloc` — Cubit for simple state, Bloc for event-driven
- **Sealed classes** for states and failures (Dart 3+)
- **Navigation**: `Navigator.of(context).pushNamed(...)` with named routes
- **DI**: Manual in `main.dart` / page constructors (no get_it)
- **Failures**: sealed `AuthFailure` hierarchy — never throw raw exceptions across layer boundaries

---

## Translation Map (Figma → Flutter)

| Figma / Web | Flutter |
|---|---|
| `<div>` (layout) | `Column`, `Row`, `Stack`, `SizedBox` |
| `display: flex; gap: 16` | `Column/Row` with `SizedBox(height/width: AppSpacing.x4)` |
| `padding: 16px` | `Padding(padding: EdgeInsets.all(AppSpacing.x4))` |
| `border-radius: 10px` | `BorderRadius.circular(AppRadius.md)` |
| `background: #667EEA` | `color: AppColors.gradientStart` |
| `font-size: 16px; font-weight: 700` | `style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700)` |
| `linear-gradient(#667EEA, #764BA2)` | `LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd])` |
| `onClick` / `onTap` | `onPressed` (buttons) or `GestureDetector.onTap` |
| React `useState` | `StatefulWidget` + `setState` or Cubit |
| React `props` | Widget constructor parameters |
| `opacity: 0.75` | `Opacity` widget or `color.withOpacity(0.75)` |
| `box-shadow` | `BoxDecoration.boxShadow` |
| SVG icon | `SvgPicture.asset('assets/icons/...')` via `flutter_svg` |

---

## Asset Handling

- Images → `assets/images/`
- Icons (SVG) → `assets/icons/`
- Declare all asset paths in `pubspec.yaml` under `flutter.assets`
- IMPORTANT: If Figma MCP returns a `localhost` URL for an image/SVG, use it directly — never substitute a placeholder
- IMPORTANT: Do NOT add new icon packages. Use Material Icons (`Icons.*`) or SVGs from Figma
- For SVG rendering: `flutter_svg` package (`SvgPicture.asset(...)`)

---

## Styling Rules

- IMPORTANT: Material 3 is enabled (`useMaterial3: true` in `AppTheme`)
- IMPORTANT: Always support dark mode — use `context.appColors` or `Theme.of(context).colorScheme` for semantic colors
- Global theme: `lib/app/theme/app_theme.dart`
- Never write standalone `TextStyle(...)` or `BoxDecoration(...)` inline — use tokens or extract to a `const` in the widget file
- Gradient overlay on illustrations: `rgba(gradientStart, 0.12) → rgba(gradientEnd, 0.12)` (pale tint)

---

## Testing Requirements

- Widget tests for every new atom/molecule → `test/core/ui/`
- TDD for domain: write test before implementing use case or repository
- Test libraries: `flutter_test`, `mocktail`, `bloc_test`
- Test behavior and state transitions, not layout
- `Key` values on interactive widgets for test targeting (e.g. `Key('login_email_field')`)

---

## File Naming & Organization

- Files: `snake_case.dart`
- Classes / widgets: `PascalCase`
- Static constants: `camelCase`
- New reusable atoms → `lib/core/ui/atoms/`
- Feature-specific widgets → `lib/features/<feature>/presentation/widgets/`
- Tests mirror source structure under `test/`

---

## Accessibility

- `Semantics` label on all interactive elements (especially icon-only buttons)
- `Tooltip` for icon-only buttons
- Touch targets ≥ 44×44px (Material guideline)
- Sufficient color contrast (WCAG AA minimum)

---

## Figma Implementation Checklist

- [ ] `get_design_context` + `get_screenshot` run first
- [ ] Reuse existing atoms from `lib/core/ui/atoms/` — check before creating new
- [ ] Figma colors → `AppColors` tokens (never hardcode hex)
- [ ] Figma typography → `AppTypography` constants
- [ ] Spacing/radius → `AppSpacing` / `AppRadius`
- [ ] Gradient → `[AppColors.gradientStart, AppColors.gradientEnd]`
- [ ] Assets downloaded to `assets/` + `pubspec.yaml` updated
- [ ] Widget tests written for any new atoms
- [ ] Visual parity validated against Figma screenshot
- [ ] Dark mode appearance checked
