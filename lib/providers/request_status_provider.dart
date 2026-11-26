import 'package:flutter/material.dart';

import '../data/models/api_models.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';

/// State for "Check your request" (src/pages/RequestStatus.jsx). No login needed.
class RequestStatusProvider extends ChangeNotifier {
  RequestStatusProvider(this._api);

  final ApiService _api;
  final requestId = TextEditingController();

  RequestStatusResult? result;
  String error = '';
  bool busy = false;

  void prefill(String id) {
    requestId.text = id.toUpperCase();
    error = '';
    result = null;
    notifyListeners();
  }

  Future<void> check() async {
    final id = requestId.text.trim().toUpperCase();
    if (busy) return;
    if (id.isEmpty) {
      error = 'Please enter your Request ID.';
      result = null;
      notifyListeners();
      return;
    }
    busy = true;
    error = '';
    result = null;
    notifyListeners();
    try {
      result = await _api.checkRequestStatus(id);
    } on ApiException catch (err) {
      error = err.message;
    } catch (_) {
      error = 'Could not check your status right now. Please try again.';
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    requestId.dispose();
    super.dispose();
  }
}
