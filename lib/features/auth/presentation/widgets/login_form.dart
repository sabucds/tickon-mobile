import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/atoms/gradient_button.dart';
import '../../../../../core/ui/tokens/app_colors.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../../../../core/ui/tokens/app_typography.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import 'auth_input_field.dart';

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
        AuthInputField(
          key: const Key('login_email_field'),
          label: 'Email',
          controller: _emailController,
          hint: 'your.email@example.com',
          errorText: _emailError,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x4),
        AuthInputField(
          key: const Key('login_password_field'),
          label: 'Password',
          controller: _passwordController,
          hint: 'Enter your password',
          errorText: _passwordError,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x2),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.gradientStart,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x6),
        GradientButton(
          label: 'Sign In',
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
          isFullWidth: true,
        ),
        const SizedBox(height: AppSpacing.x6),
        const _OrDivider(),
        const SizedBox(height: AppSpacing.x6),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                label: 'Google',
                icon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                icon: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.neutral900,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
          child: Text(
            'OR CONTINUE WITH',
            style: AppTypography.labelSm.copyWith(color: AppColors.textDisabled),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 51,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: AppSpacing.x2),
            Text(
              label,
              style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
