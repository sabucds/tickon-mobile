import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/ui/atoms/gradient_button.dart';
import '../../../../../core/ui/tokens/app_colors.dart';
import '../../../../../core/ui/tokens/app_spacing.dart';
import '../../../../../core/ui/tokens/app_typography.dart';
import '../../../../../core/utils/password_strength.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import 'auth_input_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  PasswordStrength? _passwordStrength;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    setState(() {
      _passwordStrength =
          password.isEmpty ? null : PasswordStrengthCalculator.calculate(password);
    });
  }

  bool _validate() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _firstNameError = firstName.isEmpty
          ? 'First name is required'
          : firstName.length > 50
              ? 'First name must be 50 characters or less'
              : null;

      _lastNameError = lastName.isEmpty
          ? 'Last name is required'
          : lastName.length > 50
              ? 'Last name must be 50 characters or less'
              : null;

      _usernameError = username.isEmpty
          ? 'Username is required'
          : username.length < 3
              ? 'Username must be at least 3 characters'
              : username.length > 30
                  ? 'Username must be 30 characters or less'
                  : null;

      _emailError = email.isEmpty
          ? 'Email is required'
          : !_isValidEmail(email)
              ? 'Enter a valid email'
              : null;

      _passwordError = password.isEmpty
          ? 'Password is required'
          : password.length < 8
              ? 'Password must be at least 8 characters'
              : null;

      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password'
          : confirmPassword != password
              ? 'Passwords do not match'
              : null;
    });

    return _firstNameError == null &&
        _lastNameError == null &&
        _usernameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  void _submit() {
    if (!_validate()) return;
    context.read<RegisterCubit>().register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select((RegisterCubit c) => c.state is RegisterLoading);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthInputField(
                key: const Key('register_firstName_field'),
                label: 'First Name',
                controller: _firstNameController,
                hint: 'John',
                errorText: _firstNameError,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: AuthInputField(
                key: const Key('register_lastName_field'),
                label: 'Last Name',
                controller: _lastNameController,
                hint: 'Doe',
                errorText: _lastNameError,
                textInputAction: TextInputAction.next,
                enabled: !isLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        AuthInputField(
          key: const Key('register_username_field'),
          label: 'Username',
          controller: _usernameController,
          hint: 'johndoe',
          errorText: _usernameError,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x4),
        AuthInputField(
          key: const Key('register_email_field'),
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
          key: const Key('register_password_field'),
          label: 'Password',
          controller: _passwordController,
          hint: 'Min. 8 characters',
          errorText: _passwordError,
          obscureText: true,
          textInputAction: TextInputAction.next,
          enabled: !isLoading,
        ),
        if (_passwordStrength != null) ...[
          const SizedBox(height: AppSpacing.x2),
          _PasswordStrengthIndicator(strength: _passwordStrength!),
        ],
        const SizedBox(height: AppSpacing.x4),
        AuthInputField(
          key: const Key('register_confirmPassword_field'),
          label: 'Confirm Password',
          controller: _confirmPasswordController,
          hint: 'Repeat your password',
          errorText: _confirmPasswordError,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          enabled: !isLoading,
        ),
        const SizedBox(height: AppSpacing.x6),
        GradientButton(
          label: 'Create Account',
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator({required this.strength});

  final PasswordStrength strength;

  @override
  Widget build(BuildContext context) {
    final color = PasswordStrengthCalculator.getColor(strength);
    final label = PasswordStrengthCalculator.getLabel(strength);
    final progress = switch (strength) {
      PasswordStrength.weak => 0.33,
      PasswordStrength.medium => 0.66,
      PasswordStrength.strong => 1.0,
    };

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.neutral200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(color: color),
        ),
      ],
    );
  }
}
