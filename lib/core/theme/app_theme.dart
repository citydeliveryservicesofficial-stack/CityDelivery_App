import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography: Sora (display / headings) + Plus Jakarta Sans (body), as on the website.
class AppText {
  AppText._();

  static TextStyle display({
    double size = 16,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.dark,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) => GoogleFonts.sora(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
  );

  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.text,
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        primary: AppColors.green,
        secondary: AppColors.yellow,
        surface: AppColors.light,
      ),
      scaffoldBackgroundColor: AppColors.light,
    );
    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
          .apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      splashFactory: InkRipple.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.green,
        selectionColor: AppColors.yellow.withValues(alpha: 0.5),
        selectionHandleColor: AppColors.green,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.dark,
        contentTextStyle: AppText.body(
          color: Colors.white,
          weight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
