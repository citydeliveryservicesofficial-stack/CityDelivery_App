import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../data/services/api_service.dart';

class SiteConfigProvider extends ChangeNotifier {
  SiteConfigProvider(this._api) {
    load();
  }

  final ApiService _api;

  String serviceCity = Site.serviceCity;

  Future<void> load() async {
    try {
      final config = await _api.getSiteConfig();
      final nextValue = config.serviceCity.trim();
      if (nextValue.isEmpty || nextValue == serviceCity) return;
      serviceCity = nextValue;
      notifyListeners();
    } catch (_) {}
  }
}
