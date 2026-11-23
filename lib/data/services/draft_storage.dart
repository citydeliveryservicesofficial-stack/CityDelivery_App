import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Keeps half-filled forms across app restarts ("preserve form data where practical").
/// Sensitive rider fields (Aadhaar, PAN, bank details) are never written to disk.
class DraftStorage {
  Future<Map<String, dynamic>?> load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String key, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(data));
    } catch (_) {
      // drafts are best-effort
    }
  }

  Future<void> clear(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (_) {}
  }
}
