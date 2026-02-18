import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/atoms/app_button.dart';
import '../../../../../core/ui/atoms/app_text_field.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _emailError = _emailController.text.trim().isEmpty ? 'Email is required' : null;
      _passwordError = _passwordController.text.isEmpty ? 'Password is required' : null;
    });
    return _emailError == null && _passwordError == null;
  }

  void _submit() {
    if (!_validate()) return;
    context.read<LoginCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((LoginCubit c) => c.state is LoginLoading);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('login_email_field'),
          controller: _emailController,
          label: 'Email',
          hint: 'you@example.com',
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          leading: const Icon(Icons.email_outlined),
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x4),
        AppTextField(
          key: const Key('login_password_field'),
          controller: _passwordController,
          label: 'Password',
          errorText: _passwordError,
          obscureText: true,
          textInputAction: TextInputAction.done,
          leading: const Icon(Icons.lock_outlined),
          onSubmitted: (_) => _submit(),
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppButton(
          label: 'Sign in',
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
          isFullWidth: true,
          size: AppButtonSize.lg,
        ),
      ],
    );
  }
}
