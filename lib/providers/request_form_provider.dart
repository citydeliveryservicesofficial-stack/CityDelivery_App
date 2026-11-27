import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/utils/helpers.dart';
import '../data/models/api_models.dart';
import '../data/models/upload_file.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';
import '../data/services/draft_storage.dart';
import '../data/services/request_history_storage.dart';

class RequestItemFields {
  static const keys = [
    'productName',
    'storeName',
    'storeLocation',
    'productDescription',
    'quantity',
    'estimatedBudget',
  ];

  final Map<String, TextEditingController> controllers = {};
  String category;
  final VoidCallback onChanged;

  RequestItemFields({this.category = '', required this.onChanged}) {
    for (final k in keys) {
      controllers[k] = TextEditingController(text: k == 'quantity' ? '1' : '')
        ..addListener(onChanged);
    }
  }

  String text(String k) => controllers[k]!.text.trim();

  Map<String, String> payload() => {
    'productName': text('productName'),
    'productCategory': category.trim(),
    'storeName': text('storeName'),
    'storeLocation': text('storeLocation'),
    'productDescription': text('productDescription'),
    'quantity': text('quantity'),
    'estimatedBudget': text('estimatedBudget'),
  };

  Map<String, dynamic> toJson() => {
    ...payload(),
    'category': category,
  };

  factory RequestItemFields.fromJson(
    Map<String, dynamic> json, {
    required VoidCallback onChanged,
  }) {
    final item = RequestItemFields(onChanged: onChanged);
    for (final k in keys) {
      final v = json[k];
      if (v is String && v.isNotEmpty) item.controllers[k]!.text = v;
    }
    if (json['category'] is String) item.category = json['category'] as String;
    if (json['productCategory'] is String) {
      item.category = json['productCategory'] as String;
    }
    return item;
  }

  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
  }
}

/// State + validation for the "Request a Service" form (src/pages/RequestProduct.jsx).
class RequestFormProvider extends ChangeNotifier {
  RequestFormProvider(this._api, this._drafts, this._history) {
    for (final k in textFields) {
      controllers[k] = TextEditingController(text: k == 'quantity' ? '1' : '')
        ..addListener(_scheduleSave);
    }
    _submissionKey = newSubmissionKey();
    _restoreDraft();
  }

  static const _draftKey = 'draft.productRequest.v1';
  static const maxItems = 20;

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
  final RequestHistoryStorage _history;

  final Map<String, TextEditingController> controllers = {};
  final List<RequestItemFields> extraItems = [];
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

  bool addItem() {
    if (extraItems.length >= maxItems - 1) return false;
    extraItems.add(RequestItemFields(
      category: productCategory,
      onChanged: _scheduleSave,
    ));
    notifyListeners();
    return true;
  }

  void removeItem(int index) {
    if (index < 0 || index >= extraItems.length) return;
    extraItems.removeAt(index).dispose();
    errors.clear();
    _scheduleSave();
    notifyListeners();
  }

  void setItemCategory(int index, String v) {
    if (index < 0 || index >= extraItems.length) return;
    extraItems[index].category = v;
    errors.remove('items.${index + 1}.productCategory');
    _scheduleSave();
    notifyListeners();
  }

  void clearItemError(int index, String k) {
    clearError('items.${index + 1}.$k');
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

    for (var i = 0; i < extraItems.length; i++) {
      final item = extraItems[i];
      final key = (String field) => 'items.${i + 1}.$field';
      if (item.text('productName').isEmpty) {
        e[key('productName')] = 'What product do you need?';
      } else if (item.text('productName').length < 2) {
        e[key('productName')] = 'Product name is too short.';
      }
      if (item.category.trim().isEmpty) {
        e[key('productCategory')] = 'Please choose a category.';
      }
      if (item.text('storeName').isNotEmpty &&
          item.text('storeName').length < 2) {
        e[key('storeName')] = 'Store name is too short.';
      }
      if (item.text('storeLocation').isNotEmpty &&
          item.text('storeLocation').length < 2) {
        e[key('storeLocation')] = 'Store location is too short.';
      }
      if (item.text('productDescription').isNotEmpty &&
          item.text('productDescription').length < 10) {
        e[key('productDescription')] = 'Please add a little more detail.';
      }
      final q = num.tryParse(item.text('quantity'));
      if (q == null || q % 1 != 0 || q < 1 || q > 100) {
        e[key('quantity')] = 'Quantity must be between 1 and 100.';
      }
      final bRaw = item.text('estimatedBudget');
      if (bRaw.isNotEmpty) {
        final b = num.tryParse(bRaw);
        if (b == null || b < 0) {
          e[key('estimatedBudget')] = 'Budget must be a positive number.';
        }
      }
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
    for (var i = 0; i < extraItems.length; i++) {
      for (final k in [
        'productName',
        'productCategory',
        'productDescription',
        'quantity',
        'estimatedBudget',
        'storeName',
        'storeLocation',
      ]) {
        final key = 'items.${i + 1}.$k';
        if (errors[key] != null) return key;
      }
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
    final items = <Map<String, String>>[
      {
        for (final k in RequestItemFields.keys) k: _t(k),
        'productCategory': productCategory.trim(),
      },
      for (final item in extraItems) item.payload(),
    ];
    final fields = <MapEntry<String, String>>[
      for (final k in textFields.sublist(0, 4)) MapEntry(k, _t(k)),
      MapEntry('productCategory', productCategory.trim()),
      for (final k in textFields.sublist(4)) MapEntry(k, _t(k)),
      MapEntry('items', jsonEncode(items)),
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
      await _history.remember(result!.requestId);
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
    for (final item in extraItems) {
      item.dispose();
    }
    extraItems.clear();
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
    if (d['extraItems'] is String && (d['extraItems'] as String).isNotEmpty) {
      try {
        final decoded = jsonDecode(d['extraItems'] as String);
        if (decoded is List) {
          for (final entry in decoded) {
            if (entry is Map<String, dynamic> &&
                extraItems.length < maxItems - 1) {
              extraItems.add(RequestItemFields.fromJson(
                entry,
                onChanged: _scheduleSave,
              ));
            }
          }
        }
      } catch (_) {}
    }
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
        'extraItems': jsonEncode(extraItems.map((e) => e.toJson()).toList()),
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
    for (final item in extraItems) {
      item.dispose();
    }
    super.dispose();
  }
}
