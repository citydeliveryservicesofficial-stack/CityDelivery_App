/// Central API configuration.
///
/// The website reads `VITE_API_URL` (e.g. `https://api.example.com/api`, no
/// trailing slash). The app reads the same value at build time:
///
///   flutter run --dart-define=API_URL=https://your-backend.example.com/api
///   flutter build apk --release --dart-define=API_URL=https://your-backend.example.com/api
///
/// The default below is the Android-emulator loopback of the website's default
/// (`http://localhost:5000/api`). It only works on an emulator, so ALWAYS pass
/// API_URL for physical devices and release builds.
class ApiConfig {
  ApiConfig._();

  static const String _raw = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );

  static String get baseUrl =>
      _raw.endsWith('/') ? _raw.substring(0, _raw.length - 1) : _raw;

  /// JSON requests (contact form, status lookup, config).
  static const Duration jsonTimeout = Duration(seconds: 30);

  /// Multipart requests (product image, up to 12 rider documents).
  static const Duration uploadTimeout = Duration(minutes: 3);
}
