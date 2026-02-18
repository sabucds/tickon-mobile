import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickon/app/theme/app_theme.dart';
import 'package:tickon/core/ui/atoms/app_text_field.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

void main() {
  group('AppTextField', () {
    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(hint: 'Enter email'),
      ));
      expect(find.text('Enter email'), findsOneWidget);
    });

    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(label: 'Email'),
      ));
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? captured;
      await tester.pumpWidget(_wrap(
        AppTextField(onChanged: (v) => captured = v),
      ));
      await tester.enterText(find.byType(TextField), 'hello');
      expect(captured, 'hello');
    });

    testWidgets('shows error text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(errorText: 'Required field'),
      ));
      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('shows helper text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(helperText: 'We will never share your email'),
      ));
      expect(find.text('We will never share your email'), findsOneWidget);
    });

    testWidgets('is not editable when disabled', (tester) async {
      String? captured;
      await tester.pumpWidget(_wrap(
        AppTextField(enabled: false, onChanged: (v) => captured = v),
      ));
      await tester.enterText(find.byType(TextField), 'blocked');
      expect(captured, isNull);
    });

    group('obscureText', () {
      testWidgets('hides text by default when obscureText is true', (tester) async {
        await tester.pumpWidget(_wrap(
          const AppTextField(obscureText: true, hint: 'Password'),
        ));
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.obscureText, isTrue);
      });

      testWidgets('shows toggle icon when obscureText is true', (tester) async {
        await tester.pumpWidget(_wrap(
          const AppTextField(obscureText: true),
        ));
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('toggles visibility when icon tapped', (tester) async {
        await tester.pumpWidget(_wrap(
          const AppTextField(obscureText: true),
        ));
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pump();
        final field = tester.widget<TextField>(find.byType(TextField));
        expect(field.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });
    });

    testWidgets('renders leading widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(leading: Icon(Icons.email_outlined)),
      ));
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('renders trailing widget', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppTextField(trailing: Icon(Icons.clear)),
      ));
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
  });
}
