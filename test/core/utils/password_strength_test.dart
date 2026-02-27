import 'package:flutter_test/flutter_test.dart';
import 'package:tickon/core/utils/password_strength.dart';

void main() {
  group('PasswordStrengthCalculator', () {
    group('calculate', () {
      test('returns weak for passwords less than 8 characters', () {
        expect(
          PasswordStrengthCalculator.calculate('abc'),
          PasswordStrength.weak,
        );
        expect(
          PasswordStrengthCalculator.calculate('1234567'),
          PasswordStrength.weak,
        );
      });

      test('returns weak for 8+ char passwords with only one character type', () {
        expect(
          PasswordStrengthCalculator.calculate('password'),
          PasswordStrength.weak,
        );
        expect(
          PasswordStrengthCalculator.calculate('12345678'),
          PasswordStrength.weak,
        );
        expect(
          PasswordStrengthCalculator.calculate('abcdefgh'),
          PasswordStrength.weak,
        );
      });

      test('returns medium for 8+ char passwords with 2 character types', () {
        expect(
          PasswordStrengthCalculator.calculate('Password'),
          PasswordStrength.medium,
        );
        expect(
          PasswordStrengthCalculator.calculate('password1'),
          PasswordStrength.medium,
        );
        expect(
          PasswordStrengthCalculator.calculate('abcDEFgh'),
          PasswordStrength.medium,
        );
        expect(
          PasswordStrengthCalculator.calculate('abc12345'),
          PasswordStrength.medium,
        );
      });

      test('returns strong for 8+ char passwords with 3+ character types', () {
        expect(
          PasswordStrengthCalculator.calculate('Pass123!'),
          PasswordStrength.strong,
        );
        expect(
          PasswordStrengthCalculator.calculate('Abcd@1234'),
          PasswordStrength.strong,
        );
        expect(
          PasswordStrengthCalculator.calculate('Test1234'),
          PasswordStrength.strong,
        );
      });
    });

    group('getLabel', () {
      test('returns correct labels', () {
        expect(
          PasswordStrengthCalculator.getLabel(PasswordStrength.weak),
          'Weak',
        );
        expect(
          PasswordStrengthCalculator.getLabel(PasswordStrength.medium),
          'Medium',
        );
        expect(
          PasswordStrengthCalculator.getLabel(PasswordStrength.strong),
          'Strong',
        );
      });
    });

    group('getColor', () {
      test('returns colors for each strength level', () {
        expect(
          PasswordStrengthCalculator.getColor(PasswordStrength.weak),
          isNotNull,
        );
        expect(
          PasswordStrengthCalculator.getColor(PasswordStrength.medium),
          isNotNull,
        );
        expect(
          PasswordStrengthCalculator.getColor(PasswordStrength.strong),
          isNotNull,
        );
      });
    });
  });
}
