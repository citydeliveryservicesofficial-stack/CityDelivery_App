import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RequestHistoryItem {
  const RequestHistoryItem({
    required this.requestId,
    required this.savedAt,
  });

  final String requestId;
  final String savedAt;

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'savedAt': savedAt,
      };

  static RequestHistoryItem? fromJson(Map<String, dynamic> json) {
    final id = '${json['requestId'] ?? ''}'.toUpperCase();
    if (!RegExp(r'^CDS-\d{8}-[A-Z0-9]{6}$').hasMatch(id)) return null;
    return RequestHistoryItem(
      requestId: id,
      savedAt: '${json['savedAt'] ?? DateTime.now().toIso8601String()}',
    );
  }
}

/// Device-local request history. No account, no login — stored only on this phone.
class RequestHistoryStorage {
  static const _key = 'city_delivery_request_history_v1';
  static const _maxItems = 50;

  Future<List<RequestHistoryItem>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((e) => RequestHistoryItem.fromJson(Map<String, dynamic>.from(e)))
          .whereType<RequestHistoryItem>()
          .take(_maxItems)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<RequestHistoryItem>> remember(String requestId) async {
    final id = requestId.toUpperCase();
    if (!RegExp(r'^CDS-\d{8}-[A-Z0-9]{6}$').hasMatch(id)) return load();
    final items = [
      RequestHistoryItem(
        requestId: id,
        savedAt: DateTime.now().toIso8601String(),
      ),
      ...(await load()).where((item) => item.requestId != id),
    ].take(_maxItems).toList();
    await _save(items);
    return items;
  }

  Future<void> forget(String requestId) async {
    final items = (await load())
        .where((item) => item.requestId != requestId.toUpperCase())
        .toList();
    await _save(items);
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }

  Future<void> _save(List<RequestHistoryItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode(items.map((item) => item.toJson()).toList()),
      );
    } catch (_) {}
  }
}
