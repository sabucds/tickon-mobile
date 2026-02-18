import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tickon/app/theme/app_theme.dart';
import 'package:tickon/core/ui/atoms/app_button.dart';
import 'package:tickon/features/auth/domain/entities/user.dart';
import 'package:tickon/features/auth/domain/failures/auth_failure.dart';
import 'package:tickon/features/auth/presentation/cubit/login_cubit.dart';
import 'package:tickon/features/auth/presentation/cubit/login_state.dart';
import 'package:tickon/features/auth/presentation/pages/login_page.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

// Wraps LoginView (not LoginPage) so the mock cubit is used, not the real one.
Widget _wrap(LoginCubit cubit) => MaterialApp(
      theme: AppTheme.light,
      home: BlocProvider<LoginCubit>.value(
        value: cubit,
        child: const LoginView(),
      ),
    );

void main() {
  late MockLoginCubit cubit;

  setUp(() {
    cubit = MockLoginCubit();
    when(() => cubit.state).thenReturn(const LoginInitial());
  });

  testWidgets('renders email field, password field and login button', (tester) async {
    await tester.pumpWidget(_wrap(cubit));
    expect(find.byKey(const Key('login_email_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Sign in'), findsOneWidget);
  });

  testWidgets('does not call cubit when fields are empty', (tester) async {
    await tester.pumpWidget(_wrap(cubit));
    await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
    await tester.pump();
    verifyNever(() => cubit.signIn(email: any(named: 'email'), password: any(named: 'password')));
  });

  testWidgets('calls cubit.signIn when fields are filled', (tester) async {
    when(() => cubit.signIn(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(_wrap(cubit));
    await tester.enterText(find.byKey(const Key('login_email_field')), 'user@test.com');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'secret');
    await tester.tap(find.widgetWithText(AppButton, 'Sign in'));
    await tester.pump();

    verify(() => cubit.signIn(email: 'user@test.com', password: 'secret')).called(1);
  });

  testWidgets('shows loading button when state is LoginLoading', (tester) async {
    when(() => cubit.state).thenReturn(const LoginLoading());
    await tester.pumpWidget(_wrap(cubit));
    await tester.pump();

    final button = tester.widget<AppButton>(find.byType(AppButton));
    expect(button.isLoading, isTrue);
  });

  testWidgets('shows error snackbar when state is LoginFailure', (tester) async {
    whenListen(
      cubit,
      Stream.fromIterable([
        const LoginLoading(),
        const LoginFailure(InvalidCredentials()),
      ]),
      initialState: const LoginInitial(),
    );
    await tester.pumpWidget(_wrap(cubit));
    await tester.pump(); // trigger listener
    await tester.pump(const Duration(milliseconds: 250)); // snackbar animation
    expect(find.text('Invalid email or password'), findsOneWidget);
  });

  testWidgets('shows success snackbar when state is LoginSuccess', (tester) async {
    const user = User(id: '1', email: 'user@test.com', name: 'Test User');
    whenListen(
      cubit,
      Stream.fromIterable([const LoginLoading(), LoginSuccess(user)]),
      initialState: const LoginInitial(),
    );
    await tester.pumpWidget(_wrap(cubit));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Welcome, Test User!'), findsOneWidget);
  });
}
