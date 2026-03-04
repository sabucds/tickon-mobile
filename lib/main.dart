import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/onboarding/presentation/pages/splash_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  runApp(const TickonApp());
}

class TickonApp extends StatelessWidget {
  const TickonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tickon',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/onboarding': (_) => const OnboardingPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
