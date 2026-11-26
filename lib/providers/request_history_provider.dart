import 'package:flutter/material.dart';

import '../data/models/api_models.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';
import '../data/services/request_history_storage.dart';

class RequestHistoryProvider extends ChangeNotifier {
  RequestHistoryProvider(this._api, this._storage);

  final ApiService _api;
  final RequestHistoryStorage _storage;

  List<RequestHistoryItem> entries = const [];
  final Map<String, RequestStatusResult> statuses = {};
  final Map<String, String> errors = {};
  bool busy = false;

  Future<void> load() async {
    if (busy) return;
    busy = true;
    statuses.clear();
    errors.clear();
    notifyListeners();

    entries = await _storage.load();
    notifyListeners();

    if (entries.isEmpty) {
      busy = false;
      notifyListeners();
      return;
    }

    try {
      final results = await _api.checkRequestStatuses(
        entries.map((item) => item.requestId).toList(),
      );
      for (final item in entries) {
        final result = results[item.requestId];
        if (result != null) {
          statuses[item.requestId] = result;
        } else {
          errors[item.requestId] = 'Request not found.';
        }
      }
    } on ApiException catch (err) {
      for (final item in entries) {
        errors[item.requestId] = err.message;
      }
    } catch (_) {
      for (final item in entries) {
        errors[item.requestId] = 'Could not check status.';
      }
    }

    busy = false;
    notifyListeners();
  }

  Future<void> remember(String requestId) async {
    await _storage.remember(requestId);
    busy = false;
    await load();
  }

  Future<void> forget(String requestId) async {
    await _storage.forget(requestId);
    entries = entries.where((item) => item.requestId != requestId).toList();
    statuses.remove(requestId);
    errors.remove(requestId);
    notifyListeners();
  }

  Future<void> clear() async {
    await _storage.clear();
    entries = const [];
    statuses.clear();
    errors.clear();
    notifyListeners();
  }
}
