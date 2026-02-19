/// Compile-time configuration injected via --dart-define flags.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=https://api.dev.tickon.com
///   flutter build apk --dart-define=API_BASE_URL=https://api.tickon.com
abstract final class AppConfig {
  /// Base URL for all API requests.
  /// Defaults to localhost for local development.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
