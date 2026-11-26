import '../models/api_models.dart';
import '../models/franchise_models.dart';
import '../models/upload_file.dart';
import 'api_client.dart';

/// All customer-facing endpoints used by the website (src/services/api.js).
///
/// Admin endpoints (`/admin/*`, x-api-key) are deliberately NOT part of the mobile app.
class ApiService {
  ApiService(this._client);

  final ApiClient _client;

  /// POST /requests (multipart). [fields] must already contain every field + submissionKey.
  Future<ProductRequestResult> submitProductRequest({
    required List<MapEntry<String, String>> fields,
    UploadFile? productImage,
  }) async {
    final res = await _client.postMultipart(
      '/requests',
      fields: fields,
      files: [if (productImage != null) MapEntry('productImage', productImage)],
    );
    return ProductRequestResult.fromResponse(res);
  }

  /// POST /contact (JSON). Returns the server's confirmation message.
  Future<String> submitContactMessage(Map<String, dynamic> payload) async {
    final res = await _client.postJson('/contact', payload);
    return '${res['message'] ?? ''}';
  }

  /// GET /riders/config
  Future<RiderConfig> getRiderConfig() async =>
      RiderConfig.fromResponse(await _client.getJson('/riders/config'));

  /// POST /riders/register (multipart)
  Future<RiderApplicationResult> submitRiderApplication({
    required List<MapEntry<String, String>> fields,
    required List<MapEntry<String, UploadFile>> files,
  }) async {
    final res = await _client.postMultipart(
      '/riders/register',
      fields: fields,
      files: files,
    );
    return RiderApplicationResult.fromResponse(res);
  }

  /// POST /riders/status (JSON)
  Future<RiderStatusResult> checkRiderStatus(String applicationId) async {
    final res = await _client.postJson('/riders/status', {
      'applicationId': applicationId,
    });
    return RiderStatusResult.fromResponse(res);
  }

  Future<FranchiseConfig> getFranchiseConfig() async =>
      FranchiseConfig.fromResponse(await _client.getJson('/franchises/config'));

  Future<FranchiseApplicationResult> submitFranchiseApplication({
    required List<MapEntry<String, String>> fields,
    required List<MapEntry<String, UploadFile>> files,
  }) async {
    final res = await _client.postMultipart(
      '/franchises/register',
      fields: fields,
      files: files,
    );
    return FranchiseApplicationResult.fromResponse(res);
  }

  Future<FranchiseStatusResult> checkFranchiseStatus(String applicationId) async {
    final res = await _client.postJson('/franchises/status', {
      'applicationId': applicationId,
    });
    return FranchiseStatusResult.fromResponse(res);
  }
}
