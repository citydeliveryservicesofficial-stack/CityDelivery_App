import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../core/config/api_config.dart';
import '../models/upload_file.dart';
import 'api_exception.dart';

const String _networkMessage =
    'We could not reach the server. Please check your connection and try again — your details are still in the form.';
const String _timeoutMessage =
    'The server took too long to respond. Please check your connection and try again — your details are still in the form.';

/// Thin HTTP layer. Behaves like `request()` in the website's `src/services/api.js`:
///  - network failure  -> ApiException(network: true)
///  - non-2xx or `success: false` -> ApiException(message + field summary, fieldErrors)
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> getJson(String path) async {
    return _handle(
      () => _client
          .get(_uri(path), headers: const {'Accept': 'application/json'})
          .timeout(ApiConfig.jsonTimeout),
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _handle(
      () => _client
          .post(
            _uri(path),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.jsonTimeout),
    );
  }

  /// Equivalent of `fetch(url, { method: 'POST', body: FormData })`.
  /// [fields] may repeat a key (the rider form sends `workPreferences.availabilityDays` once per day).
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required List<MapEntry<String, String>> fields,
    List<MapEntry<String, UploadFile>> files = const [],
  }) async {
    return _handle(() async {
      final request = http.MultipartRequest('POST', _uri(path));
      request.headers['Accept'] = 'application/json';

      final counts = <String, int>{};
      for (final f in fields) {
        counts[f.key] = (counts[f.key] ?? 0) + 1;
      }
      for (final f in fields) {
        if (counts[f.key]! > 1) {
          // Repeated key: send each value as its own text part (no filename => a normal form field).
          request.files.add(http.MultipartFile.fromString(f.key, f.value));
        } else {
          request.fields[f.key] = f.value;
        }
      }
      for (final f in files) {
        request.files.add(
          await http.MultipartFile.fromPath(
            f.key,
            f.value.path,
            filename: f.value.name,
            contentType: MediaType.parse(f.value.mimeType),
          ),
        );
      }
      final streamed = await _client
          .send(request)
          .timeout(ApiConfig.uploadTimeout);
      return http.Response.fromStream(streamed)
          .timeout(ApiConfig.uploadTimeout);
    });
  }

  Future<Map<String, dynamic>> _handle(
    Future<http.Response> Function() send,
  ) async {
    http.Response res;
    try {
      res = await send();
    } on TimeoutException {
      throw ApiException(_timeoutMessage, network: true);
    } on SocketException {
      throw ApiException(_networkMessage, network: true);
    } on HandshakeException {
      throw ApiException(_networkMessage, network: true);
    } on http.ClientException {
      throw ApiException(_networkMessage, network: true);
    } on FileSystemException {
      throw ApiException(
        'We could not read one of the selected files. Please choose it again and retry.',
      );
    }

    Map<String, dynamic>? data;
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      if (decoded is Map) data = Map<String, dynamic>.from(decoded);
    } catch (_) {
      // non-JSON response
    }

    final ok = res.statusCode >= 200 && res.statusCode < 300;
    if (!ok || data?['success'] == false) {
      final errors = <String, String>{};
      final raw = data?['errors'];
      if (raw is Map) {
        raw.forEach((k, v) => errors['$k'] = '$v');
      }
      final summary = errors.isEmpty
          ? ''
          : ' ${errors.entries.map((e) => '${e.key}: ${e.value}').join(' ')}';
      final message = (data?['message'] as String?)?.trim();
      throw ApiException(
        '${(message == null || message.isEmpty) ? 'Something went wrong. Please try again.' : message}$summary',
        status: res.statusCode,
        fieldErrors: errors,
      );
    }
    return data ?? <String, dynamic>{};
  }

  void dispose() => _client.close();
}
