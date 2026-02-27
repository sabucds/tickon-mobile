import 'package:flutter/material.dart';
import '../ui/tokens/app_colors.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordStrengthCalculator {
  static PasswordStrength calculate(String password) {
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    int characterTypeCount = 0;

    // Check for lowercase letters
    if (password.contains(RegExp(r'[a-z]'))) {
      characterTypeCount++;
    }

    // Check for uppercase letters
    if (password.contains(RegExp(r'[A-Z]'))) {
      characterTypeCount++;
    }

    // Check for numbers
    if (password.contains(RegExp(r'[0-9]'))) {
      characterTypeCount++;
    }

    // Check for symbols
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;~`]'))) {
      characterTypeCount++;
    }

    if (characterTypeCount >= 3) {
      return PasswordStrength.strong;
    } else if (characterTypeCount >= 2) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.weak;
    }
  }

  static Color getColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.warning;
      case PasswordStrength.strong:
        return AppColors.success;
    }
  }

  static String getLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
}
