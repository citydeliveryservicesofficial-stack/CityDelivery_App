import 'package:flutter/material.dart';

import '../data/models/api_models.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';

/// State for "Check your rider application" (src/pages/RiderStatus.jsx). No login needed.
class RiderStatusProvider extends ChangeNotifier {
  RiderStatusProvider(this._api);

  final ApiService _api;
  final applicationId = TextEditingController();

  RiderStatusResult? result;
  String error = '';
  bool busy = false;

  Future<void> check() async {
    final id = applicationId.text.trim();
    if (busy) return;
    if (id.isEmpty) {
      error = 'Please enter your Application ID.';
      result = null;
      notifyListeners();
      return;
    }
    busy = true;
    error = '';
    result = null;
    notifyListeners();
    try {
      result = await _api.checkRiderStatus(id);
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
    applicationId.dispose();
    super.dispose();
  }
}
