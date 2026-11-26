import '../../core/constants/app_constants.dart';

Map<String, dynamic> _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

String _text(dynamic value) {
  final s = value?.toString().trim() ?? '';
  return s;
}

List<String> _strings(dynamic value, List<String> fallback) {
  if (value is! List) return fallback;
  return value.map((e) => '$e').toList();
}

String formatFranchiseMoney(num amount, String currency) {
  final whole = amount.round();
  final hasDecimals = (amount - whole).abs() > 0.001;
  final value = amount.toStringAsFixed(hasDecimals ? 2 : 0);
  final parts = value.split('.');
  final grouped = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  final prefix = currency == 'INR' ? '₹' : '$currency ';
  return '$prefix$grouped${parts.length > 1 ? '.${parts[1]}' : ''}';
}

String formatFranchiseDate(DateTime? date) {
  if (date == null) return '—';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year}, ${two(date.hour)}:${two(date.minute)}';
}

class FranchiseConfig {
  const FranchiseConfig({
    this.statuses = kFranchiseStatuses,
    this.investmentCapacities = kFranchiseInvestmentCapacities,
    this.documents = const ['businessProof', 'addressProof', 'otherProof'],
    this.vehicleTypes = kFranchiseVehicleTypes,
    this.applicationFee = 1000,
    this.currency = 'INR',
    this.refundPolicy = 'Non-refundable',
    this.refundPolicyDetails = '',
    this.paymentInstructions = '',
  });

  final List<String> statuses;
  final List<String> investmentCapacities;
  final List<String> documents;
  final List<String> vehicleTypes;
  final num applicationFee;
  final String currency;
  final String refundPolicy;
  final String refundPolicyDetails;
  final String paymentInstructions;

  String get feeLabel => formatFranchiseMoney(applicationFee, currency);

  factory FranchiseConfig.fromResponse(Map<String, dynamic> response) {
    const fallback = FranchiseConfig();
    final data = _asMap(response['data']);
    return FranchiseConfig(
      statuses: _strings(data['statuses'], fallback.statuses),
      investmentCapacities: _strings(
        data['investmentCapacities'],
        fallback.investmentCapacities,
      ),
      documents: _strings(data['documents'], fallback.documents),
      vehicleTypes: _strings(data['vehicleTypes'], fallback.vehicleTypes),
      applicationFee: (data['applicationFee'] is num)
          ? data['applicationFee'] as num
          : fallback.applicationFee,
      currency: _text(data['currency']).isEmpty
          ? fallback.currency
          : _text(data['currency']),
      refundPolicy: _text(data['refundPolicy']).isEmpty
          ? fallback.refundPolicy
          : _text(data['refundPolicy']),
      refundPolicyDetails: _text(data['refundPolicyDetails']),
      paymentInstructions: _text(data['paymentInstructions']),
    );
  }
}

class FranchiseFee {
  const FranchiseFee({
    this.amount = 1000,
    this.currency = 'INR',
    this.refundPolicy = 'Non-refundable',
    this.refundPolicyDetails = '',
  });

  final num amount;
  final String currency;
  final String refundPolicy;
  final String refundPolicyDetails;

  String get label => formatFranchiseMoney(amount, currency);

  factory FranchiseFee.fromMap(Map<String, dynamic> data) {
    const fallback = FranchiseFee();
    return FranchiseFee(
      amount: data['amount'] is num ? data['amount'] as num : fallback.amount,
      currency: _text(data['currency']).isEmpty
          ? fallback.currency
          : _text(data['currency']),
      refundPolicy: _text(data['refundPolicy']).isEmpty
          ? fallback.refundPolicy
          : _text(data['refundPolicy']),
      refundPolicyDetails: _text(data['refundPolicyDetails']),
    );
  }
}

class FranchisePayment {
  const FranchisePayment({
    this.status = 'PENDING',
    this.amount = 1000,
    this.currency = 'INR',
    this.paidAt,
    this.transactionId,
    this.lastError = '',
  });

  final String status;
  final num amount;
  final String currency;
  final DateTime? paidAt;
  final String? transactionId;
  final String lastError;

  bool get isPaid => status == 'PAID';

  String get amountLabel => formatFranchiseMoney(amount, currency);

  factory FranchisePayment.fromMap(dynamic value) {
    final data = _asMap(value);
    if (data.isEmpty) return const FranchisePayment();
    return FranchisePayment(
      status: _text(data['status']).isEmpty ? 'PENDING' : _text(data['status']),
      amount: data['amount'] is num ? data['amount'] as num : 1000,
      currency: _text(data['currency']).isEmpty ? 'INR' : _text(data['currency']),
      paidAt: DateTime.tryParse(_text(data['paidAt']))?.toLocal(),
      transactionId: _text(data['transactionId']).isEmpty
          ? null
          : _text(data['transactionId']),
      lastError: _text(data['lastError']),
    );
  }
}

class FranchiseApplication {
  const FranchiseApplication({
    required this.applicationId,
    required this.applicationStatus,
    required this.nextSteps,
    this.fullName = '',
    this.city = '',
    this.area = '',
    this.franchiseId,
    this.rejectionReason = '',
    this.infoRequestMessage = '',
    this.submittedAt,
    this.updatedAt,
    this.fee = const FranchiseFee(),
    this.payment = const FranchisePayment(),
  });

  final String applicationId;
  final String applicationStatus;
  final String nextSteps;
  final String fullName;
  final String city;
  final String area;
  final String? franchiseId;
  final String rejectionReason;
  final String infoRequestMessage;
  final DateTime? submittedAt;
  final DateTime? updatedAt;
  final FranchiseFee fee;
  final FranchisePayment payment;

  factory FranchiseApplication.fromMap(Map<String, dynamic> data) {
    return FranchiseApplication(
      applicationId: _text(data['applicationId']),
      applicationStatus: _text(data['applicationStatus']),
      nextSteps: _text(data['nextSteps']),
      fullName: _text(data['fullName']),
      city: _text(data['city']),
      area: _text(data['area']),
      franchiseId:
          _text(data['franchiseId']).isEmpty ? null : _text(data['franchiseId']),
      rejectionReason: _text(data['rejectionReason']),
      infoRequestMessage: _text(data['infoRequestMessage']),
      submittedAt: DateTime.tryParse(_text(data['submittedAt']))?.toLocal(),
      updatedAt: DateTime.tryParse(_text(data['updatedAt']))?.toLocal(),
      fee: FranchiseFee.fromMap(_asMap(data['fee'])),
      payment: FranchisePayment.fromMap(data['payment']),
    );
  }
}

class FranchiseApplicationResult {
  const FranchiseApplicationResult({
    required this.applicationId,
    required this.message,
    this.duplicate = false,
    this.application,
  });

  final String applicationId;
  final String message;
  final bool duplicate;
  final FranchiseApplication? application;

  factory FranchiseApplicationResult.fromResponse(
    Map<String, dynamic> response,
  ) {
    final data = _asMap(response['data']);
    return FranchiseApplicationResult(
      applicationId: _text(data['applicationId']),
      message: _text(response['message']),
      duplicate: data['duplicate'] == true,
      application: data['applicationId'] is String
          ? FranchiseApplication.fromMap(data)
          : null,
    );
  }
}

class FranchiseStatusResult {
  const FranchiseStatusResult({required this.application});

  final FranchiseApplication application;

  factory FranchiseStatusResult.fromResponse(Map<String, dynamic> response) {
    final data = _asMap(response['data']);
    return FranchiseStatusResult(
      application: FranchiseApplication.fromMap(data),
    );
  }
}
