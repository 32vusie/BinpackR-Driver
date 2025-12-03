import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(8, 116, 13, 1);

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromRGBO(8, 116, 13, 1), 
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.orange),
    textTheme: _textTheme,
    iconTheme: _iconTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 8, 116, 13), 
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(secondary: Colors.orange),
    textTheme: _textTheme,
    iconTheme: _iconTheme,
  );

  static const TextTheme _textTheme = TextTheme(
    titleLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
  );

  static const IconThemeData _iconTheme = IconThemeData(
    size: 24,
  );

  // Gradients
  static LinearGradient gradient = const LinearGradient(
    colors: [Color.fromARGB(255, 8, 116, 13), Colors.green],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
