import 'package:flutter/material.dart';

/// Tailwind `brand.*` palette from tailwind.config.js plus the hard-coded
/// colours used on the Home page.
class AppColors {
  AppColors._();

  static const yellow = Color(0xFFFFC928);
  static const yellowSoft = Color(0xFFFFE58A);
  static const yellowDeep = Color(0xFFF5B800);
  static const green = Color(0xFF168447);
  static const greenHover = Color(0xFF106B38);
  static const dark = Color(0xFF111713);
  static const light = Color(0xFFFFFDF5);
  static const text = Color(0xFF17221A);
  static const muted = Color(0xFF747B72);

  // Home page specifics
  static const homeGreen = Color(0xFF0F8A2F);
  static const homeDark = Color(0xFF16161A);
  static const homeBody = Color(0xFF5B5A55);
  static const whatsapp = Color(0xFF25D366);

  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const red700 = Color(0xFFB91C1C);
  static const red50 = Color(0xFFFEF2F2);
  static const amber50 = Color(0xFFFFFBEB);
  static const amber900 = Color(0xFF78350F);
  static const amber100 = Color(0xFFFEF3C7);
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald900 = Color(0xFF064E3B);
  static const emerald600 = Color(0xFF059669);
  static const blue100 = Color(0xFFDBEAFE);
  static const blue900 = Color(0xFF1E3A8A);
  static const violet50 = Color(0xFFF5F3FF);
  static const violet100 = Color(0xFFEDE9FE);
  static const violet900 = Color(0xFF4C1D95);
  static const red100 = Color(0xFFFEE2E2);
  static const red900 = Color(0xFF7F1D1D);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate700 = Color(0xFF334155);
}

class AppShadows {
  AppShadows._();

  /// shadow-soft: 0 10px 40px -12px rgba(17,23,19,.18)
  static const soft = [
    BoxShadow(
      color: Color(0x2E111713),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 10),
    ),
  ];

  /// shadow-lift: 0 24px 60px -20px rgba(17,23,19,.28)
  static const lift = [
    BoxShadow(
      color: Color(0x47111713),
      blurRadius: 60,
      spreadRadius: -20,
      offset: Offset(0, 24),
    ),
  ];

  /// shadow-glow: 0 12px 32px -8px rgba(22,132,71,.55)
  static const glow = [
    BoxShadow(
      color: Color(0x8C168447),
      blurRadius: 32,
      spreadRadius: -8,
      offset: Offset(0, 12),
    ),
  ];
}
