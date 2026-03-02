import 'package:flutter/material.dart';

abstract final class AppColors {
  // --- Palette ---
  static const Color primary100 = Color(0xFFEDE9FE);
  static const Color primary300 = Color(0xFFA78BFA);
  static const Color primary500 = Color(0xFF7C3AED);
  static const Color primary700 = Color(0xFF5B21B6);
  static const Color primary900 = Color(0xFF2E1065);

  static const Color neutral0   = Color(0xFFFFFFFF);
  static const Color neutral50  = Color(0xFFF8F8F8);
  static const Color neutral100 = Color(0xFFF1F1F1);
  static const Color neutral200 = Color(0xFFE4E4E4);
  static const Color neutral400 = Color(0xFFA0A0A0);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral800 = Color(0xFF1F1F1F);
  static const Color neutral900 = Color(0xFF0A0A0A);

  static const Color success = Color(0xFF16A34A);
  static const Color error   = Color(0xFFDC2626);
  static const Color warning = Color(0xFFD97706);

  // --- Brand gradient (from Figma) ---
  static const Color gradientStart = Color(0xFF667EEA);
  static const Color gradientEnd   = Color(0xFF764BA2);

  // --- Semantic aliases ---
  static const Color background    = neutral50;
  static const Color surface       = neutral0;
  static const Color onSurface     = neutral800;
  static const Color border        = neutral200;
  static const Color textPrimary   = neutral900;
  static const Color textSecondary = neutral600;
  static const Color textDisabled  = neutral400;
}
