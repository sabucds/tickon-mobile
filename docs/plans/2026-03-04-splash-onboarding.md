# Plan: Splash + Onboarding screens

Date: 2026-03-04

## Goal
Implement the Splash and Onboarding screens matching the Figma designs.
Entry point: app launch → Splash (2s timer) → Onboarding (3 pages) → Login.

## Files to create
- `lib/features/onboarding/presentation/pages/splash_page.dart`
- `lib/features/onboarding/presentation/pages/onboarding_page.dart`

## Files to modify
- `lib/main.dart` — change `home` from `LoginPage` to `SplashPage`, add named routes

## Design spec (from Figma)

### Splash
- Full-screen gradient: gradientStart → gradientEnd, 160° diagonal
- 3 decorative circles: translucent white (6% opacity), positioned top-right, bottom-left, center-right
- Logo: 72×72 white container, radius 20, shadow; "T" text 48px bold white
- App name: "Tickon" 36px bold white, spacing x3 below logo
- Tagline: "Your events. Your way." 16px white 75% opacity
- Loading dots (3): active = gradient pill 24×8, inactive = white 30% opacity 8×8 circle
- Auto-navigate to onboarding after 2.5s

### Onboarding (PageView, 3 pages)
- White `AppColors.surface` background
- "Skip" top-right → pushReplacementNamed('/login')
- Illustration: 280×280 circle, pale gradient tint bg (gradientStart 12% → gradientEnd 12%), 96px emoji with drop shadow
- Title: AppTypography.displaySm centered
- Description: AppTypography.bodyLg centered, textSecondary
- Progress dots: inactive = neutral200 8px, active = gradient pill 24×8
- Button: GradientButton full-width ("Next" / "Get Started")
- "Get Started" on last page → pushReplacementNamed('/login')

### 3 pages content
| # | Emoji | Title | Description |
|---|---|---|---|
| 1 | 🎉 | Discover Amazing Events | From concerts to sports — find what excites you, happening near you. |
| 2 | ⚡ | Book in Seconds, Not Minutes | Choose your seats, pay securely, get your ticket instantly. |
| 3 | 🎟️ | Your Tickets, Always with You | Access all your tickets offline. No printing, no hassle. |

## Navigation / Routes
```
/ (SplashPage)  →  /onboarding (OnboardingPage)  →  /login (LoginPage)
```
Named routes added to MaterialApp in main.dart.

## No state management needed
- Splash: `initState` timer → Navigator
- Onboarding: `StatefulWidget` + `PageController` + `setState`

## How to verify
- `flutter run` — splash shows gradient + logo, auto-advances after 2.5s
- Onboarding pages swipe correctly, dots animate
- "Skip" and "Get Started" both navigate to login
- Hot restart shows splash again

## Rollback
- Revert `main.dart` home back to `LoginPage`
- Delete the two new page files
