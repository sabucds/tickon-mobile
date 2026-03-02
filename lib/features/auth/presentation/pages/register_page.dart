import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/tokens/app_colors.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AuthRepositoryImpl();
    return BlocProvider(
      create: (_) => RegisterCubit(
        signUpUseCase: SignUp(repository),
        signInUseCase: SignIn(repository),
      ),
      child: const RegisterView(),
    );
  }
}

/// Public so it can be wrapped with a mock cubit in tests.
class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  String _failureMessage(AuthFailure failure) => switch (failure) {
        DuplicateEmail() => 'Email already exists',
        DuplicateUsername() => 'Username already taken',
        ValidationFailure(:final errors) => errors.values.first,
        ServerFailure(:final message) => message,
        _ => 'Registration failed',
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        switch (state) {
          case RegisterSuccess(:final user):
            Navigator.of(context).pushReplacementNamed('/home');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${user.name}!')),
            );
          case RegisterFailure(:final failure):
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
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.x8),
                const AuthHeader(subtitle: 'Create your account'),
                const SizedBox(height: AppSpacing.x8),
                const RegisterForm(),
                const SizedBox(height: AppSpacing.x6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gradientStart,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
