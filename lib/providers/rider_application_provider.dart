import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/helpers.dart';
import '../data/models/api_models.dart';
import '../data/models/upload_file.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';
import '../data/services/draft_storage.dart';

/// State + validation for the 6-step rider application (src/pages/RiderRegister.jsx).
/// Field paths are the same dotted keys the website/back-end use, e.g. `address.pincode`.
class RiderApplicationProvider extends ChangeNotifier {
  RiderApplicationProvider(this._api, this._drafts) {
    for (final path in _textPaths) {
      controllers[path] = TextEditingController(
        text: path == 'address.city' ? 'Vellore' : '',
      )..addListener(_scheduleSave);
    }
    _submissionKey = newSubmissionKey();
    _restoreDraft();
    loadConfig();
  }

  static const _draftKey = 'draft.riderApplication.v1';

  /// Group -> keys, in the order the website appends them to FormData.
  static const _groups = <String, List<String>>{
    'personalInformation': ['fullName', 'dateOfBirth', 'gender'],
    'contactInformation': [
      'mobile',
      'whatsapp',
      'email',
      'emergencyContactName',
      'emergencyContactNumber',
    ],
    'address': ['residentialAddress', 'city', 'area', 'pincode'],
    'drivingInformation': ['licenceNumber', 'experience'],
    'vehicleInformation': [
      'ownsVehicle',
      'assistanceRequired',
      'vehicleType',
      'registrationNumber',
      'brand',
      'model',
      'insuranceAvailable',
    ],
    'workPreferences': [
      'preferredWorkingArea',
      'workType',
      'preferredWorkingHours',
      'availabilityDays',
    ],
    'identityVerification': [
      'aadhaarConsent',
      'aadhaarNumber',
      'panConsent',
      'panNumber',
      'additionalNotes',
    ],
    'paymentInformation': [
      'submitted',
      'accountHolderName',
      'bankName',
      'accountNumber',
      'confirmAccountNumber',
      'ifscCode',
      'upiId',
    ],
    'consents': ['accurate', 'terms', 'processing'],
  };

  static const _textPaths = [
    'personalInformation.fullName',
    'contactInformation.mobile',
    'contactInformation.whatsapp',
    'contactInformation.email',
    'contactInformation.emergencyContactName',
    'contactInformation.emergencyContactNumber',
    'address.residentialAddress',
    'address.city',
    'address.area',
    'address.pincode',
    'drivingInformation.licenceNumber',
    'drivingInformation.experience',
    'vehicleInformation.registrationNumber',
    'vehicleInformation.brand',
    'vehicleInformation.model',
    'workPreferences.preferredWorkingArea',
    'workPreferences.preferredWorkingHours',
    'identityVerification.aadhaarNumber',
    'identityVerification.panNumber',
    'identityVerification.additionalNotes',
    'paymentInformation.accountHolderName',
    'paymentInformation.bankName',
    'paymentInformation.accountNumber',
    'paymentInformation.confirmAccountNumber',
    'paymentInformation.ifscCode',
    'paymentInformation.upiId',
  ];

  /// Never written to the on-device draft (government IDs, bank details, consents).
  static const _neverPersist = {
    'drivingInformation.licenceNumber',
    'identityVerification.aadhaarNumber',
    'identityVerification.panNumber',
    'identityVerification.additionalNotes',
    'paymentInformation.accountHolderName',
    'paymentInformation.bankName',
    'paymentInformation.accountNumber',
    'paymentInformation.confirmAccountNumber',
    'paymentInformation.ifscCode',
    'paymentInformation.upiId',
  };

  final ApiService _api;
  final DraftStorage _drafts;

  final Map<String, TextEditingController> controllers = {};

  /// Non-text values (selects, toggles, dates, lists).
  final Map<String, dynamic> _v = {
    'personalInformation.dateOfBirth': '',
    'personalInformation.gender': '',
    'vehicleInformation.ownsVehicle': 'true',
    'vehicleInformation.assistanceRequired': false,
    'vehicleInformation.vehicleType': '',
    'vehicleInformation.insuranceAvailable': false,
    'workPreferences.workType': '',
    'workPreferences.availabilityDays': <String>[],
    'identityVerification.aadhaarConsent': false,
    'identityVerification.panConsent': false,
    'paymentInformation.submitted': 'false',
    'consents.accurate': false,
    'consents.terms': false,
    'consents.processing': false,
  };

  final Map<String, UploadFile?> files = {};
  Map<String, String> errors = {};

  RiderConfig config = const RiderConfig();
  String configError = '';

  int step = 0;
  bool submitting = false;
  String formError = '';
  RiderApplicationResult? result;

  late String _submissionKey;
  Timer? _saveTimer;

  // ------------------------------------------------------------------ access
  bool _isText(String path) => !_v.containsKey(path);

  /// Raw value of a field path.
  dynamic raw(String path) =>
      _isText(path) ? controllers[path]!.text : _v[path];

  String str(String path) => '${raw(path) ?? ''}';
  bool flag(String path) => _v[path] == true;
  List<String> get availabilityDays =>
      List<String>.from(_v['workPreferences.availabilityDays'] as List);

  String _t(String path) => str(path).trim();
  String? error(String path) => errors[path];

  void set(String path, dynamic value) {
    if (_isText(path)) {
      controllers[path]!.text = '$value';
    } else {
      _v[path] = value;
      _scheduleSave();
    }
    errors.remove(path);
    notifyListeners();
  }

  void clearError(String path) {
    if (errors.containsKey(path)) {
      errors.remove(path);
      notifyListeners();
    }
  }

  void toggleDay(String day) {
    final list = availabilityDays;
    list.contains(day) ? list.remove(day) : list.add(day);
    _v['workPreferences.availabilityDays'] = list;
    errors.remove('workPreferences.availabilityDays');
    _scheduleSave();
    notifyListeners();
  }

  void setFile(String key, UploadFile? file) {
    files[key] = file;
    errors.remove('documents.$key');
    notifyListeners();
  }

  // ------------------------------------------------------------------ config
  Future<void> loadConfig() async {
    try {
      config = await _api.getRiderConfig();
      configError = '';
    } catch (_) {
      configError = 'Using the default rider requirements. Our team will confirm the available options.';
    }
    notifyListeners();
  }

  // --------------------------------------------------------------- documents
  List<String> get requiredDocs {
    final keys = <String>[
      'profilePhoto',
      'licenceFront',
      'licenceBack',
      'panDocument',
    ];
    if (str('vehicleInformation.ownsVehicle') == 'true') {
      keys.addAll(['vehicleRcFront', 'vehicleRcBack', 'vehiclePhoto']);
      if (flag('vehicleInformation.insuranceAvailable') ||
          config.requireInsurance)
        keys.add('insuranceDocument');
    }
    if (str('identityVerification.aadhaarNumber').isNotEmpty ||
        config.requireAadhaar)
      keys.add('aadhaarDocument');
    return keys.toSet().toList();
  }

  /// `RIDER_DOCUMENTS.filter(doc => docs.includes(doc.key) || !doc.when)`
  List<RiderDocSpec> get visibleDocs {
    final docs = requiredDocs;
    return kRiderDocuments
        .where((d) => docs.contains(d.key) || d.when == null)
        .toList();
  }

  // -------------------------------------------------------------- validation
  Map<String, String> validateStep(int s) {
    final e = <String, String>{};
    final emailRe = kEmailRegex;

    if (s == 0) {
      if (_t('personalInformation.fullName').length < 2) {
        e['personalInformation.fullName'] = 'Please enter your full name.';
      }
      if (!isValidPhone(_t('contactInformation.mobile'))) {
        e['contactInformation.mobile'] = 'Please enter a valid mobile number.';
      }
      if (_t('contactInformation.whatsapp').isNotEmpty &&
          !isValidPhone(_t('contactInformation.whatsapp'))) {
        e['contactInformation.whatsapp'] =
            'Please enter a valid WhatsApp number.';
      }
      if (_t('contactInformation.email').isNotEmpty &&
          !emailRe.hasMatch(_t('contactInformation.email'))) {
        e['contactInformation.email'] = 'Please enter a valid email address.';
      }
      final dobStr = _t('personalInformation.dateOfBirth');
      final dob = DateTime.tryParse(dobStr);
      final ageYears = dob == null
          ? double.nan
          : DateTime.now().difference(dob).inHours / (365.25 * 24);
      if (dobStr.isEmpty || ageYears.isNaN || ageYears < 18 || ageYears > 80) {
        e['personalInformation.dateOfBirth'] =
            'You must be at least 18 years old.';
      }
    }

    if (s == 1) {
      if (_t('address.residentialAddress').length < 5) {
        e['address.residentialAddress'] =
            'Please enter your full residential address.';
      }
      if (_t('address.city').length < 2)
        e['address.city'] = 'Please enter your city.';
      if (_t('address.area').length < 2)
        e['address.area'] = 'Please enter your area / locality.';
      if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(_t('address.pincode'))) {
        e['address.pincode'] = 'Please enter a valid 6-digit pincode.';
      }
      final em = _t('contactInformation.emergencyContactNumber');
      if (em.isNotEmpty && !isValidPhone(em)) {
        e['contactInformation.emergencyContactNumber'] =
            'Please enter a valid emergency number.';
      }
    }

    if (s == 2) {
      if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9\s-]{3,39}$')
          .hasMatch(_t('drivingInformation.licenceNumber'))) {
        e['drivingInformation.licenceNumber'] =
            'Please enter your driving licence number.';
      }
      if (_t('drivingInformation.experience').length < 2) {
        e['drivingInformation.experience'] =
            'Please tell us your driving experience.';
      }
      final owns = str('vehicleInformation.ownsVehicle') == 'true';
      if (!owns && !flag('vehicleInformation.assistanceRequired')) {
        e['vehicleInformation.assistanceRequired'] =
            'Please confirm if you need vehicle assistance.';
      }
      if (owns) {
        if (!config.allowedVehicleTypes.contains(
          _t('vehicleInformation.vehicleType'),
        )) {
          e['vehicleInformation.vehicleType'] =
              'Please choose an available vehicle type.';
        }
        if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9\s-]{3,29}$')
            .hasMatch(_t('vehicleInformation.registrationNumber'))) {
          e['vehicleInformation.registrationNumber'] =
              'Please enter the vehicle registration number.';
        }
        if (_t('vehicleInformation.brand').length < 2)
          e['vehicleInformation.brand'] = 'Please enter the vehicle brand.';
        if (_t('vehicleInformation.model').length < 2)
          e['vehicleInformation.model'] = 'Please enter the vehicle model.';
      }
    }

    if (s == 3) {
      if (_t('workPreferences.preferredWorkingArea').length < 2) {
        e['workPreferences.preferredWorkingArea'] =
            'Please enter your preferred working area.';
      }
      if (!kRiderWorkTypes.contains(_t('workPreferences.workType'))) {
        e['workPreferences.workType'] = 'Please choose a work type.';
      }
      if (availabilityDays.isEmpty)
        e['workPreferences.availabilityDays'] =
            'Please choose at least one day.';
    }

    if (s == 4) {
      if (str('paymentInformation.submitted') == 'true') {
        if (_t('paymentInformation.accountHolderName').length < 2) {
          e['paymentInformation.accountHolderName'] =
              'Please enter the account holder name.';
        }
        if (_t('paymentInformation.bankName').length < 2) {
          e['paymentInformation.bankName'] = 'Please enter your bank name.';
        }
        if (!RegExp(r'^[0-9]{6,18}$')
            .hasMatch(_t('paymentInformation.accountNumber'))) {
          e['paymentInformation.accountNumber'] =
              'Please enter a valid account number.';
        }
        if (_t('paymentInformation.confirmAccountNumber') !=
            _t('paymentInformation.accountNumber')) {
          e['paymentInformation.confirmAccountNumber'] =
              'Account numbers do not match.';
        }
        if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
            .hasMatch(_t('paymentInformation.ifscCode').toUpperCase())) {
          e['paymentInformation.ifscCode'] = 'Please enter a valid IFSC code.';
        }
      }
      if (_t('identityVerification.aadhaarNumber').isNotEmpty &&
          !flag('identityVerification.aadhaarConsent')) {
        e['identityVerification.aadhaarConsent'] =
            'Please consent to Aadhaar verification.';
      }
      final pan = _t('identityVerification.panNumber').toUpperCase();
      if (pan.isEmpty) {
        e['identityVerification.panNumber'] = 'Please enter your PAN number.';
      } else if (!RegExp(r'^[A-Z0-9]{10}$').hasMatch(pan)) {
        e['identityVerification.panNumber'] =
            'Please enter a valid PAN number.';
      }
      if (!flag('identityVerification.panConsent')) {
        e['identityVerification.panConsent'] =
            'Please consent to PAN verification.';
      }
    }

    if (s == 5) {
      for (final key in requiredDocs) {
        if (files[key] == null)
          e['documents.$key'] = 'Please upload this document.';
      }
      if (!flag('consents.accurate'))
        e['consents.accurate'] = 'Please confirm your information is accurate.';
      if (!flag('consents.terms'))
        e['consents.terms'] = 'Please agree to the rider terms.';
      if (!flag('consents.processing'))
        e['consents.processing'] =
            'Please consent to processing your information.';
    }
    return e;
  }

  // -------------------------------------------------------------- navigation
  /// Returns true when the step advanced.
  bool next() {
    final errs = validateStep(step);
    errors = errs;
    if (errs.isNotEmpty) {
      formError = 'Please fix the highlighted fields to continue.';
      notifyListeners();
      return false;
    }
    formError = '';
    step++;
    _scheduleSave();
    notifyListeners();
    return true;
  }

  void back() {
    formError = '';
    step = step > 0 ? step - 1 : 0;
    notifyListeners();
  }

  void goTo(int index) {
    if (index < step) {
      step = index;
      formError = '';
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------ submit
  Future<void> submit() async {
    if (submitting) return;
    final errs = validateStep(5);
    errors = errs;
    if (errs.isNotEmpty) {
      formError = 'Please fix the highlighted fields and try again.';
      notifyListeners();
      return;
    }
    submitting = true;
    formError = '';
    notifyListeners();

    final fields = <MapEntry<String, String>>[];
    _groups.forEach((group, keys) {
      for (final key in keys) {
        if (key == 'confirmAccountNumber') continue;
        final path = '$group.$key';
        final value = raw(path);
        if (value is List) {
          if (value.isEmpty) fields.add(MapEntry(path, ''));
          for (final item in value) {
            fields.add(MapEntry(path, '$item'));
          }
        } else if (value is bool) {
          fields.add(MapEntry(path, value ? 'true' : 'false'));
        } else {
          fields.add(MapEntry(path, '$value'.trim()));
        }
      }
    });
    fields
      ..add(const MapEntry('website', ''))
      ..add(MapEntry('submissionKey', _submissionKey));

    final uploads = <MapEntry<String, UploadFile>>[
      for (final e in files.entries)
        if (e.value != null) MapEntry(e.key, e.value!),
    ];

    try {
      result = await _api.submitRiderApplication(
        fields: fields,
        files: uploads,
      );
      await _drafts.clear(_draftKey);
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

  void reset() {
    for (final e in controllers.entries) {
      e.value.text = e.key == 'address.city' ? 'Vellore' : '';
    }
    _v
      ..['personalInformation.dateOfBirth'] = ''
      ..['personalInformation.gender'] = ''
      ..['vehicleInformation.ownsVehicle'] = 'true'
      ..['vehicleInformation.assistanceRequired'] = false
      ..['vehicleInformation.vehicleType'] = ''
      ..['vehicleInformation.insuranceAvailable'] = false
      ..['workPreferences.workType'] = ''
      ..['workPreferences.availabilityDays'] = <String>[]
      ..['identityVerification.aadhaarConsent'] = false
      ..['identityVerification.panConsent'] = false
      ..['paymentInformation.submitted'] = 'false'
      ..['consents.accurate'] = false
      ..['consents.terms'] = false
      ..['consents.processing'] = false;
    files.clear();
    errors = {};
    step = 0;
    formError = '';
    result = null;
    _submissionKey = newSubmissionKey();
    _drafts.clear(_draftKey);
    notifyListeners();
  }

  // ------------------------------------------------------------------- draft
  Future<void> _restoreDraft() async {
    final d = await _drafts.load(_draftKey);
    if (d == null || result != null) return;
    final texts = d['texts'];
    if (texts is Map) {
      for (final path in _textPaths) {
        final v = texts[path];
        final untouched =
            controllers[path]!.text.isEmpty || path == 'address.city';
        if (v is String && v.isNotEmpty && untouched)
          controllers[path]!.text = v;
      }
    }
    final vals = d['values'];
    if (vals is Map) {
      for (final k in _v.keys) {
        if (_neverPersist.contains(k) ||
            k.startsWith('consents.') ||
            k.endsWith('Consent'))
          continue;
        if (!vals.containsKey(k)) continue;
        if (_v[k] is bool && vals[k] is bool) _v[k] = vals[k];
        if (_v[k] is String && vals[k] is String) _v[k] = vals[k];
        if (_v[k] is List && vals[k] is List)
          _v[k] = (vals[k] as List).map((e) => '$e').toList();
      }
    }
    if (d['step'] is int)
      step = (d['step'] as int).clamp(0, kRiderSteps.length - 1);
    if (d['submissionKey'] is String &&
        (d['submissionKey'] as String).isNotEmpty) {
      _submissionKey = d['submissionKey'] as String;
    }
    notifyListeners();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 700), () {
      if (result != null) return;
      _drafts.save(_draftKey, {
        'texts': {
          for (final p in _textPaths)
            if (!_neverPersist.contains(p)) p: controllers[p]!.text,
        },
        'values': {
          for (final e in _v.entries)
            if (!_neverPersist.contains(e.key) &&
                !e.key.startsWith('consents.') &&
                !e.key.endsWith('Consent'))
              e.key: e.value,
        },
        'step': step,
        'submissionKey': _submissionKey,
      });
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
