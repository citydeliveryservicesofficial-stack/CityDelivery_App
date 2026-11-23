import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central API configuration.
///
/// The app reads `API_URL` from `.env`, or from a build-time define:
///
///   flutter run --dart-define=API_URL=https://your-backend.example.com/api
///
/// A build-time define takes precedence over `.env`. The fallback below is the
/// Android-emulator loopback and only works on an emulator.
class ApiConfig {
  ApiConfig._();

  static const _fallback = 'http://10.0.2.2:5000/api';

  static String get _raw {
    const defined = String.fromEnvironment('API_URL');
    if (defined.isNotEmpty) return defined;
    final loaded = dotenv.env['API_URL'];
    if (loaded != null && loaded.isNotEmpty) return loaded;
    return _fallback;
  }

  static String get baseUrl {
    final raw = _raw;
    return raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
  }

  /// JSON requests (contact form, status lookup, config).
  static const Duration jsonTimeout = Duration(seconds: 30);

  /// Multipart requests (product image, up to 12 rider documents).
  static const Duration uploadTimeout = Duration(minutes: 3);
}
