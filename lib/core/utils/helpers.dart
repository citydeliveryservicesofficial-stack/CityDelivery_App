import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

/// Same idea as `newKey()` on the website: one key per form, reused on every retry so the
/// server never creates duplicates.
String newSubmissionKey() {
  final r = Random.secure();
  String hex(int n) =>
      List.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${(8 + r.nextInt(4)).toRadixString(16)}${hex(3)}-${hex(12)}';
}

final RegExp kEmailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
final RegExp kPhoneRegex = RegExp(r'^\+?[\d\s()-]{7,18}$');

bool isValidPhone(String v) =>
    kPhoneRegex.hasMatch(v) && v.replaceAll(RegExp(r'\D'), '').length >= 7;

class Launcher {
  Launcher._();

  static Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> url(String url) => open(Uri.parse(url));
  static Future<bool> tel(String phone) =>
      open(Uri(scheme: 'tel', path: phone));
  static Future<bool> mail(String email) =>
      open(Uri(scheme: 'mailto', path: email));

  /// Same URL the website's floating WhatsApp button builds.
  static Future<bool> whatsapp() {
    final digits = Site.phone.replaceAll(RegExp(r'\D'), '');
    final number = digits.length == 10 ? '91$digits' : digits;
    return url('https://wa.me/$number?text=Hello%20City%20Delivery%20Services');
  }
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

String formatDateTime(DateTime? d) {
  if (d == null) return '—';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  final ap = d.hour >= 12 ? 'pm' : 'am';
  return '${d.day} ${months[d.month - 1]} ${d.year}, $h:$m $ap';
}
