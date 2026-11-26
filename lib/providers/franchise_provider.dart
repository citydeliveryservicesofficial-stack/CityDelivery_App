import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/helpers.dart';
import '../data/models/franchise_models.dart';
import '../data/models/upload_file.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';
import '../data/services/draft_storage.dart';

class FranchiseProvider extends ChangeNotifier {
  FranchiseProvider(this._api, this._drafts) {
    controllers['city'] = TextEditingController(text: Site.serviceCity);
    for (final key in _textFields) {
      final controller = controllers.putIfAbsent(
        key,
        () => TextEditingController(),
      );
      controller.addListener(_scheduleSave);
    }
    for (final controller in vehicleCounts.values) {
      controller.addListener(_scheduleSave);
    }
    otherVehicleType.addListener(_scheduleSave);
    _submissionKey = 'franchise_${newSubmissionKey()}';
    _restore();
    loadConfig();
  }

  static const _draftKey = 'draft.franchiseApplication.v1';
  static const _lastIdKey = 'franchise.lastApplicationId';

  static const _textFields = [
    'fullName',
    'mobile',
    'email',
    'state',
    'district',
    'city',
    'preferredOperatingArea',
    'pincode',
    'fullAddress',
    'businessExperience',
    'motivation',
  ];

  final ApiService _api;
  final DraftStorage _drafts;
  final Map<String, TextEditingController> controllers = {};
  final Map<String, TextEditingController> vehicleCounts = {
    for (final type in kFranchiseVehicleTypes) type: TextEditingController(),
  };
  final TextEditingController otherVehicleType = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final Map<String, UploadFile?> files = {
    for (final doc in kFranchiseDocuments) doc.key: null,
  };

  late String _submissionKey;
  Timer? _draftTimer;
  bool _configRequested = false;

  FranchiseConfig config = const FranchiseConfig();
  bool loadingConfig = true;

  String investmentCapacity = '';
  String hasOfficeOrShop = '';
  bool accurate = false;
  bool contactConsent = false;
  Map<String, String> errors = {};
  String formError = '';
  bool submitting = false;
  FranchiseApplicationResult? result;

  FranchiseStatusResult? statusResult;
  bool checkingStatus = false;
  String statusError = '';

  String get applicationId =>
      result?.applicationId ?? statusResult?.application.applicationId ?? '';

  int get vehicleTotal => vehicleRows.fold(0, (sum, row) => sum + row.count);

  List<({String type, int count, String otherType})> get vehicleRows {
    final rows = <({String type, int count, String otherType})>[];
    for (final type in kFranchiseVehicleTypes) {
      final parsed = int.tryParse(vehicleCounts[type]!.text.trim()) ?? 0;
      if (parsed <= 0) continue;
      rows.add(
        (
          type: type,
          count: parsed > 1000 ? 1000 : parsed,
          otherType: otherVehicleType.text.trim(),
        ),
      );
    }
    return rows;
  }

  String? error(String key) => errors[key];

  void clearError(String key) {
    if (!errors.containsKey(key)) return;
    errors.remove(key);
    formError = '';
    notifyListeners();
  }

  void set(String key, String value) {
    controllers[key]?.text = value;
    clearError(key);
  }

  String raw(String key) => controllers[key]?.text.trim() ?? '';

  Future<void> loadConfig({bool force = false}) async {
    if (_configRequested && !force) return;
    _configRequested = true;
    loadingConfig = true;
    notifyListeners();
    try {
      config = await _api.getFranchiseConfig();
    } catch (_) {
      config = const FranchiseConfig();
    } finally {
      loadingConfig = false;
      notifyListeners();
    }
  }

  void setInvestment(String value) {
    investmentCapacity = value;
    clearError('investmentCapacity');
    _scheduleSave();
    notifyListeners();
  }

  void setOffice(String value) {
    hasOfficeOrShop = value;
    clearError('hasOfficeOrShop');
    _scheduleSave();
    notifyListeners();
  }

  void setConsent(String key, bool value) {
    if (key == 'accurate') accurate = value;
    if (key == 'contact') contactConsent = value;
    notifyListeners();
  }

  void setVehicle(String type, String value) {
    vehicleCounts[type]?.text = value;
    clearError('vehicles');
  }

  void setFile(String key, UploadFile? file) {
    files[key] = file;
    notifyListeners();
  }

  bool _validate() {
    final found = <String, String>{};

    if (raw('fullName').length < 2) {
      found['fullName'] = 'Full name must be between 2 and 80 characters.';
    }
    final mobile = raw('mobile');
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15 || !isValidPhone(mobile)) {
      found['mobile'] = 'Please enter a valid mobile number.';
    }
    if (!kEmailRegex.hasMatch(raw('email')) || raw('email').length > 120) {
      found['email'] = 'Please enter a valid email address.';
    }
    for (final e in [
      ('state', 'State'),
      ('district', 'District'),
      ('city', 'City / town'),
      ('preferredOperatingArea', 'Preferred operating area'),
    ]) {
      final value = raw(e.$1);
      if (value.length < 2) {
        found[e.$1] = '${e.$2} is required.';
      }
    }
    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(raw('pincode'))) {
      found['pincode'] = 'Please enter a valid 6-digit PIN code.';
    }
    if (raw('fullAddress').length < 5) {
      found['fullAddress'] = 'Full address must be between 5 and 300 characters.';
    }
    if (investmentCapacity.isEmpty) {
      found['investmentCapacity'] = 'Please choose an investment capacity.';
    }
    if (hasOfficeOrShop.isEmpty) {
      found['hasOfficeOrShop'] =
          'Please tell us whether you have an office or shop.';
    }
    final otherCount = int.tryParse(vehicleCounts['Other']?.text.trim() ?? '') ?? 0;
    if (otherCount > 0 && otherVehicleType.text.trim().isEmpty) {
      found['vehicles'] = 'Please describe the other vehicle type.';
    }
    if (!accurate) {
      found['consents.accurate'] =
          'Please confirm your information is accurate.';
    }
    if (!contactConsent) {
      found['consents.contact'] =
          'Please agree to be contacted about your application.';
    }

    errors = found;
    formError = found.isEmpty
        ? ''
        : 'Please fix the highlighted fields and try again.';
    notifyListeners();
    return found.isEmpty;
  }

  Future<void> submit() async {
    if (submitting) return;
    if (!_validate()) return;

    submitting = true;
    formError = '';
    notifyListeners();

    final fields = <MapEntry<String, String>>[];
    for (final key in _textFields) {
      fields.add(MapEntry(key, raw(key)));
    }
    fields
      ..add(MapEntry('investmentCapacity', investmentCapacity))
      ..add(MapEntry('hasOfficeOrShop', hasOfficeOrShop))
      ..add(MapEntry('numberOfVehicles', '$vehicleTotal'));

    final rows = vehicleRows;
    for (var i = 0; i < rows.length; i += 1) {
      final row = rows[i];
      fields
        ..add(MapEntry('vehicles.$i.type', row.type))
        ..add(MapEntry('vehicles.$i.count', '${row.count}'));
      if (row.type == 'Other') {
        fields.add(MapEntry('vehicles.$i.otherType', row.otherType));
      }
    }

    fields
      ..add(MapEntry('consents.accurate', accurate.toString()))
      ..add(MapEntry('consents.contact', contactConsent.toString()))
      ..add(const MapEntry('website', ''))
      ..add(MapEntry('submissionKey', _submissionKey));

    final uploads = <MapEntry<String, UploadFile>>[
      for (final entry in files.entries)
        if (entry.value != null) MapEntry(entry.key, entry.value!),
    ];

    try {
      result = await _api.submitFranchiseApplication(
        fields: fields,
        files: uploads,
      );
      await _drafts.clear(_draftKey);
      if (result!.applicationId.isNotEmpty) {
        statusController.text = result!.applicationId;
        await _drafts.save(_lastIdKey, {'id': result!.applicationId});
      }
      errors = {};
      formError = '';
    } on ApiException catch (err) {
      errors = Map.of(err.fieldErrors);
      formError = err.message;
    } catch (_) {
      formError = 'Could not submit your application. Please try again.';
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  Future<void> checkStatus({String? applicationId}) async {
    if (checkingStatus) return;
    final id = (applicationId ?? statusController.text).trim().toUpperCase();
    statusController.text = id;
    if (!RegExp(r'^FRANCH-\d{8}-[A-Z0-9]{6}$').hasMatch(id)) {
      statusError = 'Please enter a valid application ID.';
      statusResult = null;
      notifyListeners();
      return;
    }

    checkingStatus = true;
    statusError = '';
    statusResult = null;
    notifyListeners();
    try {
      statusResult = await _api.checkFranchiseStatus(id);
      await _drafts.save(_lastIdKey, {'id': id});
    } on ApiException catch (err) {
      statusError = err.message;
    } catch (_) {
      statusError = 'We could not check your status. Please try again.';
    } finally {
      checkingStatus = false;
      notifyListeners();
    }
  }

  void resetForm() {
    for (final key in _textFields) {
      controllers[key]?.text = key == 'city' ? Site.serviceCity : '';
    }
    for (final controller in vehicleCounts.values) {
      controller.clear();
    }
    otherVehicleType.clear();
    investmentCapacity = '';
    hasOfficeOrShop = '';
    accurate = false;
    contactConsent = false;
    for (final key in files.keys.toList()) {
      files[key] = null;
    }
    errors = {};
    formError = '';
    result = null;
    _submissionKey = 'franchise_${newSubmissionKey()}';
    _drafts.clear(_draftKey);
    notifyListeners();
  }

  void _scheduleSave() {
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 400), _saveDraft);
  }

  Future<void> _saveDraft() async {
    final data = <String, dynamic>{};
    for (final key in _textFields) {
      data[key] = raw(key);
    }
    data['investmentCapacity'] = investmentCapacity;
    data['hasOfficeOrShop'] = hasOfficeOrShop;
    for (final entry in vehicleCounts.entries) {
      data['vehicle.${entry.key}'] = entry.value.text;
    }
    data['otherVehicleType'] = otherVehicleType.text;
    await _drafts.save(_draftKey, data);
  }

  Future<void> _restore() async {
    final saved = await _drafts.load(_draftKey);
    if (saved != null) {
      for (final key in _textFields) {
        final value = saved[key]?.toString() ?? '';
        if (value.isNotEmpty || key != 'city') controllers[key]?.text = value;
      }
      investmentCapacity = saved['investmentCapacity']?.toString() ?? '';
      hasOfficeOrShop = saved['hasOfficeOrShop']?.toString() ?? '';
      for (final type in kFranchiseVehicleTypes) {
        vehicleCounts[type]?.text = saved['vehicle.$type']?.toString() ?? '';
      }
      otherVehicleType.text = saved['otherVehicleType']?.toString() ?? '';
    }
    final last = await _drafts.load(_lastIdKey);
    final lastId = last?['id']?.toString() ?? '';
    if (lastId.isNotEmpty && statusController.text.isEmpty) {
      statusController.text = lastId;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    for (final controller in controllers.values) {
      controller.dispose();
    }
    for (final controller in vehicleCounts.values) {
      controller.dispose();
    }
    otherVehicleType.dispose();
    statusController.dispose();
    super.dispose();
  }
}
