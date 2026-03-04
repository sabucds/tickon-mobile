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

## Figma Component Inventory

These components exist in the Figma file (`xFOXoRhMFaGNeXi8raLuvc`) and have corresponding Flutter widget targets. IMPORTANT: **When implementing any screen that uses these patterns, check for the existing Flutter widget first before building from scratch.**

### Navigation

#### `BottomNavBar` — target: `lib/core/ui/atoms/bottom_nav_bar.dart`
- 4 tabs: Home, Explore, Tickets, Profile
- Active tab: `primary500` top-bar indicator + bold label
- Badge: gradient pill (e.g. unread ticket count)
- Height: 64px · border-top: 1.5px `neutral200` / dark: `#2E2E2E`
- Dark mode: `neutral800` background

#### `AppBar` variants — target: `lib/core/ui/atoms/app_bar.dart`
- **Greeting**: avatar (36px) + "Good morning, Name 👋" + notification bell
- **Back+Title**: back icon-btn + centered title + optional trailing action
- **Section**: left-aligned title + optional subtitle + trailing icon-btn
- Icon buttons: 40×40px, radius 12, `neutral50` bg / `neutral200` border

#### `SearchBar` — target: `lib/core/ui/atoms/search_bar.dart`
- Height: 50px · radius: 14px
- Default: search icon + placeholder + gradient filter button (32px)
- Focused: `primary500` border + 3px ring, clear × icon replaces filter

#### `CategoryChip` — target: `lib/core/ui/atoms/category_chip.dart`
- Default: white bg, `neutral200` border, `neutral600` text
- Active: `primary100` bg, `primary500` border + text
- Gradient active: gradient bg, white text (use for "All" / selected filter)
- Height: ~32px · `AppRadius.full` · padding: 8×16

#### `SectionHeader` — target: `lib/core/ui/atoms/section_header.dart`
- Title (`headingSm bold`) + optional "See all" gradient text link
- Use between content sections on list/home screens

---

### Event Cards

#### `EventCardFeatured` — target: `lib/features/events/presentation/widgets/event_card_featured.dart`
- Width: 320px · image height: 180px · radius: 20px
- Gradient overlay on image (transparent → black 75%)
- Badge: status pill (trending/new/almost/sold-out) top-left
- Save button: frosted glass circle top-right; filled red when saved
- Footer: price tag (gradient text) + "Book Now" gradient button
- Sold-out: `opacity 0.75`, greyed price + disabled button

```dart
EventCardFeatured(
  event: event,
  onTap: () => _openDetail(event),
  onSave: () => _toggleSave(event),
  isSaved: isSaved,
)
```

#### `EventCardList` — target: `lib/features/events/presentation/widgets/event_card_list.dart`
- Full-width · radius 16 · padding 14px · shadow `0 2 12 6%`
- Left: 80×80 image (radius 12) OR date-badge widget
- Right: category label (gradient text) + title + date + venue + price + attendee avatars
- Badge: "You're going" pill when user has ticket

```dart
EventCardList(
  event: event,
  isAttending: isAttending,
  onTap: () => _openDetail(event),
)
```

#### `EventCardCompact` — target: `lib/features/events/presentation/widgets/event_card_compact.dart`
- Width: 160px · image height: 90px · radius: 14px
- For horizontal scroll grids (nearby, same category)
- Price shown as gradient text; free = `success` green; sold-out = `neutral400`

#### `DateBadge` — target: `lib/core/ui/atoms/date_badge.dart`
- `primary100` bg · month (9px bold uppercase `primary500`) + day (18px bold)
- Use in `EventCardList` when no image thumbnail is available

#### `EventStatusBadge` — target: `lib/core/ui/atoms/event_status_badge.dart`
- Variants: `trending` (gradient), `new` (success green), `almostSoldOut` (warning amber), `soldOut` (neutral), `booked` (success), `free` (blue)
- Height: ~26px · `AppRadius.full` · 700 weight · fontSize 11–12px

---

### Booking Flow

#### `TicketTypeRow` — target: `lib/features/booking/presentation/widgets/ticket_type_row.dart`
- Full-width · radius 16 · border 1.5px
- Default: `neutral200` border; selected: `primary500` border + faint `primary` tint bg
- Left: ticket name + description + price (gradient text / green for free)
- Right: quantity stepper (minus 32px `neutral100` / `primary100` when active; plus 32px gradient)
- Disabled minus when qty = 0

```dart
TicketTypeRow(
  ticket: ticketType,
  quantity: qty,
  onDecrement: _decrement,
  onIncrement: _increment,
)
```

#### `PriceSummaryCard` — target: `lib/features/booking/presentation/widgets/price_summary_card.dart`
- Radius 20 · shadow `0 4 20 7%`
- Line items: label + value rows; discount row uses `success` green
- Footer: `neutral50` bg · total label + gradient total value (20px bold)

#### `QRTicketCard` — target: `lib/features/booking/presentation/widgets/qr_ticket_card.dart`
- Gradient header (event name, venue, date/time/seat row)
- Perforated divider: dashed line + circle cutouts on edges
- Body: QR code widget (dark bg) + holder name + ticket type + reference ID

---

### Utility / Feedback

#### `EmptyState` — target: `lib/core/ui/atoms/empty_state.dart`
- Illustration: 120px circle with gradient tint bg + emoji/icon
- Title (`headingSm`) + description (`bodyMd textSecondary`) + optional CTA button
- Variants: `noTickets`, `noResults`, `noSaved` (pass `emoji`, `title`, `description`, `ctaLabel`)

```dart
EmptyState(
  emoji: '🎟️',
  title: 'No tickets yet',
  description: 'Explore what\'s happening near you.',
  ctaLabel: 'Browse Events',
  onCta: _browseEvents,
)
```

#### `AppToast` — target: `lib/core/ui/atoms/app_toast.dart`
- Radius 16 · shadow `0 8 32 16%` · elevated above bottom nav
- Variants: `success`, `error`, `info`, `warning`
- Icon: 36×36 radius 10; content: title (`bodyMd bold`) + description (`bodySm`)
- Show via `ScaffoldMessenger` snackbar with custom widget, or an overlay

#### `SkeletonLoader` — target: `lib/core/ui/atoms/skeleton_loader.dart`
- Shimmer animation: `neutral200 → neutral100`, 1.5s cycle
- Variants: `featuredCard`, `listCard`, `compactCard` — match dimensions of real cards exactly

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
