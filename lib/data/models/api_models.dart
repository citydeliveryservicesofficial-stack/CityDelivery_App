import '../../core/constants/app_constants.dart';

Map<String, dynamic> _asMap(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

/// Response of `POST /requests`. The website renders `{...res.data, message: res.message}`.
class ProductRequestResult {
  ProductRequestResult({
    required this.requestId,
    required this.duplicate,
    required this.message,
    this.teamNotification,
    this.confirmationEmail,
  });

  final String requestId;
  final bool duplicate;
  final String message;

  /// `notifications.team` — 'sent' when the team email went out.
  final String? teamNotification;

  /// `notifications.confirmationEmail` — 'failed' when the customer mail failed.
  final String? confirmationEmail;

  bool get teamOk => teamNotification == 'sent';

  factory ProductRequestResult.fromResponse(Map<String, dynamic> res) {
    final data = _asMap(res['data']);
    final notifications = _asMap(data['notifications']);
    return ProductRequestResult(
      requestId: '${data['requestId'] ?? ''}',
      duplicate: data['duplicate'] == true,
      message: '${res['message'] ?? ''}',
      teamNotification: notifications['team']?.toString(),
      confirmationEmail: notifications['confirmationEmail']?.toString(),
    );
  }
}

/// Response of `GET /requests/:requestId/status` (`response.data`).
class RequestStatusResult {
  RequestStatusResult({
    required this.requestId,
    required this.status,
    required this.nextSteps,
    this.createdAt,
    this.updatedAt,
  });

  final String requestId;
  final String status;
  final String nextSteps;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory RequestStatusResult.fromResponse(Map<String, dynamic> res) =>
      RequestStatusResult.fromJson(_asMap(res['data']));

  factory RequestStatusResult.fromJson(Map<String, dynamic> d) => RequestStatusResult(
        requestId: '${d['requestId'] ?? ''}',
        status: '${d['status'] ?? ''}',
        nextSteps: '${d['nextSteps'] ?? ''}',
        createdAt: DateTime.tryParse('${d['createdAt'] ?? ''}')?.toLocal(),
        updatedAt: DateTime.tryParse('${d['updatedAt'] ?? ''}')?.toLocal(),
      );
}

/// Response of `POST /riders/register` (the website renders `response.data`).
class RiderApplicationResult {
  RiderApplicationResult({
    required this.applicationId,
    required this.duplicate,
    required this.message,
  });

  final String applicationId;
  final bool duplicate;
  final String message;

  factory RiderApplicationResult.fromResponse(Map<String, dynamic> res) {
    final data = _asMap(res['data']);
    return RiderApplicationResult(
      applicationId: '${data['applicationId'] ?? ''}',
      duplicate: data['duplicate'] == true,
      message: '${data['message'] ?? res['message'] ?? ''}',
    );
  }
}

/// Response of `POST /riders/status` (`response.data`).
class RiderStatusResult {
  RiderStatusResult({
    required this.applicationId,
    required this.applicationStatus,
    required this.active,
    required this.nextSteps,
    this.riderId,
    this.documentRequestMessage,
    this.rejectionReason,
    this.submittedAt,
    this.updatedAt,
  });

  final String applicationId;
  final String applicationStatus;
  final bool active;
  final String nextSteps;
  final String? riderId;
  final String? documentRequestMessage;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? updatedAt;

  static String? _s(dynamic v) {
    final s = v?.toString() ?? '';
    return s.isEmpty ? null : s;
  }

  factory RiderStatusResult.fromResponse(Map<String, dynamic> res) {
    final d = _asMap(res['data']);
    return RiderStatusResult(
      applicationId: '${d['applicationId'] ?? ''}',
      applicationStatus: '${d['applicationStatus'] ?? ''}',
      active: d['active'] == true,
      nextSteps: '${d['nextSteps'] ?? ''}',
      riderId: _s(d['riderId']),
      documentRequestMessage: _s(d['documentRequestMessage']),
      rejectionReason: _s(d['rejectionReason']),
      submittedAt: DateTime.tryParse('${d['submittedAt'] ?? ''}')?.toLocal(),
      updatedAt: DateTime.tryParse('${d['updatedAt'] ?? ''}')?.toLocal(),
    );
  }
}

/// Response of `GET /riders/config`. Defaults match `DEFAULT_CONFIG` in RiderRegister.jsx.
class RiderConfig {
  const RiderConfig({
    this.serviceArea = 'Vellore',
    this.workTypes = kRiderWorkTypes,
    this.availabilityDays = kRiderAvailabilityDays,
    this.allowedVehicleTypes = kRiderVehicleTypes,
    this.requireInsurance = true,
    this.requireAadhaar = false,
  });

  final String serviceArea;
  final List<String> workTypes;
  final List<String> availabilityDays;
  final List<String> allowedVehicleTypes;
  final bool requireInsurance;
  final bool requireAadhaar;

  static List<String> _list(dynamic v, List<String> fallback) {
    if (v is List) return v.map((e) => '$e').toList();
    return fallback;
  }

  /// Same shallow-merge semantics as `{...DEFAULT_CONFIG, ...response.data}`.
  factory RiderConfig.fromResponse(Map<String, dynamic> res) {
    const d = RiderConfig();
    final data = _asMap(res['data']);
    final hasReq = data['requirements'] is Map;
    final req = _asMap(data['requirements']);
    return RiderConfig(
      serviceArea: data['serviceArea']?.toString() ?? d.serviceArea,
      workTypes: _list(data['workTypes'], d.workTypes),
      availabilityDays: _list(data['availabilityDays'], d.availabilityDays),
      allowedVehicleTypes: _list(
        data['allowedVehicleTypes'],
        d.allowedVehicleTypes,
      ),
      requireInsurance: hasReq
          ? req['requireInsurance'] == true
          : d.requireInsurance,
      requireAadhaar: hasReq ? req['requireAadhaar'] == true : d.requireAadhaar,
    );
  }
}
