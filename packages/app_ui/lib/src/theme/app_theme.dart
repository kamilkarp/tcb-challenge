import 'package:flutter/material.dart';

/// {@macro app_theme}
/// The Default App [ThemeData].
/// {endtemplate}
class AppTheme {
  /// {@app_theme}
  const AppTheme();

  /// Default ThemeData for App UI.
  ThemeData get themeData {
    return ThemeData(
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
    );
  }

  ColorScheme get _colorScheme {
    return ColorScheme.fromSwatch(
      accentColor: const Color(0xFF13B9FF),
    );
  }

  AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      centerTitle: true,
      color: Color(0xFF13B9FF),
    );
  }
}
