/// Equivalent of the website's `ApiError` (src/services/api.js).
class ApiException implements Exception {
  ApiException(
    this.message, {
    this.status,
    Map<String, String>? fieldErrors,
    this.network = false,
  }) : fieldErrors = fieldErrors ?? const {};

  final String message;
  final int? status;

  /// Server-side per-field validation errors (`data.errors`).
  final Map<String, String> fieldErrors;

  /// True when the server could not be reached at all.
  final bool network;

  @override
  String toString() => message;
}
