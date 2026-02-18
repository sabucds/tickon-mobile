import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../../../../core/ui/tokens/app_typography.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/usecases/sign_in.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(SignIn(AuthRepositoryImpl())),
      child: const LoginView(),
    );
  }
}

/// Public so it can be wrapped with a mock cubit in tests.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  String _failureMessage(AuthFailure failure) => switch (failure) {
        InvalidCredentials() => 'Invalid email or password',
        ServerFailure(:final message) => message,
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginSuccess(:final user):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${user.name}!')),
            );
          case LoginFailure(:final failure):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_failureMessage(failure)),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          default:
            break;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.x6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.x12),
                Text(
                  'Welcome back',
                  style: AppTypography.displaySm,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Sign in to your account',
                  style: AppTypography.bodyMd,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.x8),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
