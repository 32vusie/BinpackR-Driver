import 'package:flutter/material.dart';

class AppFonts {
  static const String primaryFont = 'Roboto'; // Font family name from pubspec.yaml

  static TextTheme textTheme = const TextTheme(
    titleLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w500, fontSize: 14),
    titleMedium: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 16),
    titleSmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 14),
    bodyLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 16),
    bodyMedium: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 14),
    labelLarge: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w500, fontSize: 14),
    bodySmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 12),
    labelSmall: TextStyle(fontFamily: primaryFont, fontWeight: FontWeight.w400, fontSize: 10),
  );
}
