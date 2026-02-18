import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickon/app/theme/app_theme.dart';
import 'package:tickon/core/ui/atoms/app_button.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

void main() {
  group('AppButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(label: 'Buy Ticket', onPressed: () {}),
      ));
      expect(find.text('Buy Ticket'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(
        AppButton(label: 'Tap me', onPressed: () => called = true),
      ));
      await tester.tap(find.byType(AppButton));
      expect(called, isTrue);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(label: 'Loading', onPressed: () {}, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('does not call onPressed when isLoading is true', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(
        AppButton(label: 'Loading', onPressed: () => called = true, isLoading: true),
      ));
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      expect(called, isFalse);
    });

    testWidgets('does not call onPressed when disabled (onPressed is null)', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppButton(label: 'Disabled'),
      ));
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      // no callback — just verifying no exception thrown
    });

    testWidgets('renders leading widget alongside label', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'With Icon',
          onPressed: () {},
          leading: const Icon(Icons.confirmation_number),
        ),
      ));
      expect(find.text('With Icon'), findsOneWidget);
      expect(find.byIcon(Icons.confirmation_number), findsOneWidget);
    });

    group('variants', () {
      for (final variant in AppButtonVariant.values) {
        testWidgets('renders ${variant.name} variant without error', (tester) async {
          await tester.pumpWidget(_wrap(
            AppButton(label: variant.name, onPressed: () {}, variant: variant),
          ));
          expect(find.text(variant.name), findsOneWidget);
        });
      }
    });

    group('sizes', () {
      for (final size in AppButtonSize.values) {
        testWidgets('renders ${size.name} size without error', (tester) async {
          await tester.pumpWidget(_wrap(
            AppButton(label: size.name, onPressed: () {}, size: size),
          ));
          expect(find.text(size.name), findsOneWidget);
        });
      }
    });
  });
}
