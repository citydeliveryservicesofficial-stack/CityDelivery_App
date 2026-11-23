import 'dart:async';

import 'package:flutter/material.dart';

import '../core/utils/helpers.dart';
import '../data/models/api_models.dart';
import '../data/models/upload_file.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';
import '../data/services/draft_storage.dart';

/// State + validation for the "Request a Service" form (src/pages/RequestProduct.jsx).
class RequestFormProvider extends ChangeNotifier {
  RequestFormProvider(this._api, this._drafts) {
    for (final k in textFields) {
      controllers[k] = TextEditingController(text: k == 'quantity' ? '1' : '')
        ..addListener(_scheduleSave);
    }
    _submissionKey = newSubmissionKey();
    _restoreDraft();
  }

  static const _draftKey = 'draft.productRequest.v1';

  /// Order == order of `INITIAL` in the website, which is the FormData order.
  static const textFields = [
    'customerName',
    'email',
    'phone',
    'productName',
    'storeName',
    'storeLocation',
    'productDescription',
    'quantity',
    'estimatedBudget',
    'deliveryAddress',
    'city',
    'postalCode',
    'additionalInstructions',
  ];

  /// Top-to-bottom order of the form, used to scroll to the first error.
  static const fieldOrder = [
    'customerName',
    'email',
    'phone',
    'productName',
    'productCategory',
    'productDescription',
    'quantity',
    'estimatedBudget',
    'productImage',
    'storeName',
    'storeLocation',
    'deliveryAddress',
    'city',
    'postalCode',
    'additionalInstructions',
    'prohibitedItemsAccepted',
  ];

  final ApiService _api;
  final DraftStorage _drafts;

  final Map<String, TextEditingController> controllers = {};
  String productCategory = '';
  bool prohibitedItemsAccepted = false;
  UploadFile? image;

  Map<String, String> errors = {};
  bool submitting = false;
  String formError = '';
  ProductRequestResult? result;

  late String _submissionKey;
  Timer? _saveTimer;

  String text(String k) => controllers[k]!.text;
  String _t(String k) => text(k).trim();

  // ---------------------------------------------------------------- mutations
  void setCategory(String v) {
    productCategory = v;
    errors.remove('productCategory');
    _scheduleSave();
    notifyListeners();
  }

  void setProhibited(bool v) {
    prohibitedItemsAccepted = v;
    errors.remove('prohibitedItemsAccepted');
    notifyListeners();
  }

  void setImage(UploadFile? f) {
    image = f;
    errors.remove('productImage');
    notifyListeners();
  }

  void clearError(String k) {
    if (errors.containsKey(k)) {
      errors.remove(k);
      notifyListeners();
    }
  }

  // --------------------------------------------------------------- validation
  Map<String, String> validate() {
    final e = <String, String>{};
    const requiredMsg = {
      'customerName': 'Please tell us your name.',
      'phone': 'Please enter your mobile number.',
      'productName': 'What product do you need?',
      'productCategory': 'Please choose a category.',
      'deliveryAddress': 'Where should we deliver it?',
      'city': 'Please enter the city.',
      'postalCode': 'Please enter the postal code.',
    };
    String t(String k) =>
        k == 'productCategory' ? productCategory.trim() : _t(k);
    requiredMsg.forEach((k, msg) {
      if (t(k).isEmpty) e[k] = msg;
    });

    if (!e.containsKey('customerName') && t('customerName').length < 2) {
      e['customerName'] = 'Name must be at least 2 characters.';
    }
    if (t('email').isNotEmpty && !kEmailRegex.hasMatch(t('email'))) {
      e['email'] = 'Please enter a valid email address.';
    }
    if (!e.containsKey('phone')) {
      final digits = t('phone').replaceAll(RegExp(r'\D'), '');
      if (!kPhoneRegex.hasMatch(t('phone')) ||
          digits.length < 7 ||
          digits.length > 15) {
        e['phone'] = 'Please enter a valid mobile number.';
      }
    }
    if (!e.containsKey('productName') && t('productName').length < 2) {
      e['productName'] = 'Product name is too short.';
    }
    if (t('storeName').isNotEmpty && t('storeName').length < 2)
      e['storeName'] = 'Store name is too short.';
    if (t('storeLocation').isNotEmpty && t('storeLocation').length < 2) {
      e['storeLocation'] = 'Store location is too short.';
    }
    if (t('productDescription').isNotEmpty &&
        t('productDescription').length < 10) {
      e['productDescription'] =
          'Please add a little more detail (at least 10 characters).';
    }
    if (!e.containsKey('deliveryAddress') && t('deliveryAddress').length < 5) {
      e['deliveryAddress'] = 'Please enter the full delivery address.';
    }
    if (!e.containsKey('postalCode') &&
        !RegExp(r'^[A-Za-z0-9][A-Za-z0-9\s-]{2,10}$')
            .hasMatch(t('postalCode'))) {
      e['postalCode'] = 'Please enter a valid postal code.';
    }
    final q = num.tryParse(t('quantity'));
    if (q == null || q % 1 != 0 || q < 1 || q > 100)
      e['quantity'] = 'Quantity must be between 1 and 100.';

    final rawBudget = text('estimatedBudget');
    if (rawBudget != '') {
      final b = num.tryParse(rawBudget.trim().isEmpty ? '0' : rawBudget.trim());
      if (b == null || b < 0)
        e['estimatedBudget'] = 'Budget must be a positive number.';
    }
    if (!prohibitedItemsAccepted) {
      e['prohibitedItemsAccepted'] =
          'Please confirm that your parcel contains only permitted items.';
    }
    return e;
  }

  /// Key of the topmost field that currently shows an error.
  String? get firstErrorKey {
    for (final k in fieldOrder) {
      if (errors[k] != null) return k;
    }
    return errors.keys.isEmpty ? null : errors.keys.first;
  }

  // ------------------------------------------------------------------- submit
  Future<void> submit() async {
    if (submitting) return;
    formError = '';
    final errs = validate();
    errors = errs;
    if (errs.isNotEmpty) {
      formError = 'Please fix the highlighted fields and try again.';
      notifyListeners();
      return;
    }

    // Same field set and order as the website's FormData.
    final fields = <MapEntry<String, String>>[
      for (final k in textFields.sublist(0, 4)) MapEntry(k, _t(k)),
      MapEntry('productCategory', productCategory.trim()),
      for (final k in textFields.sublist(4)) MapEntry(k, _t(k)),
      const MapEntry('website', ''), // honeypot — always empty
      MapEntry('submissionKey', _submissionKey),
      MapEntry(
        'prohibitedItemsAccepted',
        prohibitedItemsAccepted ? 'true' : 'false',
      ),
    ];

    submitting = true;
    notifyListeners();
    try {
      result = await _api.submitProductRequest(
        fields: fields,
        productImage: image,
      );
      await _drafts.clear(_draftKey);
    } on ApiException catch (err) {
      if (err.fieldErrors.isNotEmpty) errors = Map.of(err.fieldErrors);
      formError = err.message;
    } catch (_) {
      formError = 'Something went wrong. Please try again.';
    } finally {
      submitting = false;
      notifyListeners();
    }
  }

  /// "Submit another request" — a brand-new request gets a brand-new key.
  void reset() {
    for (final k in textFields) {
      controllers[k]!.text = k == 'quantity' ? '1' : '';
    }
    productCategory = '';
    prohibitedItemsAccepted = false;
    image = null;
    errors = {};
    formError = '';
    result = null;
    _submissionKey = newSubmissionKey();
    _drafts.clear(_draftKey);
    notifyListeners();
  }

  // -------------------------------------------------------------------- draft
  Future<void> _restoreDraft() async {
    final d = await _drafts.load(_draftKey);
    if (d == null || result != null) return;
    for (final k in textFields) {
      final v = d[k];
      final untouched =
          controllers[k]!.text.isEmpty ||
          (k == 'quantity' && controllers[k]!.text == '1');
      if (v is String && v.isNotEmpty && untouched) controllers[k]!.text = v;
    }
    if (d['productCategory'] is String)
      productCategory = d['productCategory'] as String;
    if (d['submissionKey'] is String &&
        (d['submissionKey'] as String).isNotEmpty) {
      _submissionKey = d['submissionKey'] as String;
    }
    notifyListeners();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 600), () {
      if (result != null) return;
      _drafts.save(_draftKey, {
        for (final k in textFields) k: text(k),
        'productCategory': productCategory,
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
