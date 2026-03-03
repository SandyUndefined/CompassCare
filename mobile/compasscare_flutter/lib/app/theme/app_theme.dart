import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Color(0xFF0E7C86);
  static const _primaryFontFamily = 'Merriweather';
  static const _secondaryFontFamily = 'NotoSans';

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _secondaryFontFamily,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _withPrimaryTypography(baseTheme.textTheme),
      primaryTextTheme: _withPrimaryTypography(baseTheme.primaryTextTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: _withPrimaryFont(
          baseTheme.textTheme.titleLarge,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _secondaryFontFamily,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _withPrimaryTypography(baseTheme.textTheme),
      primaryTextTheme: _withPrimaryTypography(baseTheme.primaryTextTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: _withPrimaryFont(
          baseTheme.textTheme.titleLarge,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static TextTheme _withPrimaryTypography(TextTheme textTheme) {
    return textTheme.copyWith(
      displayLarge: _withPrimaryFont(textTheme.displayLarge),
      displayMedium: _withPrimaryFont(textTheme.displayMedium),
      displaySmall: _withPrimaryFont(textTheme.displaySmall),
      headlineLarge: _withPrimaryFont(textTheme.headlineLarge),
      headlineMedium: _withPrimaryFont(textTheme.headlineMedium),
      headlineSmall: _withPrimaryFont(textTheme.headlineSmall),
      titleLarge: _withPrimaryFont(textTheme.titleLarge),
      titleMedium: _withPrimaryFont(textTheme.titleMedium),
      titleSmall: _withPrimaryFont(textTheme.titleSmall),
    );
  }

  static TextStyle _withPrimaryFont(
    TextStyle? baseStyle, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    return (baseStyle ?? const TextStyle()).copyWith(
      fontFamily: _primaryFontFamily,
      color: color,
      fontWeight: fontWeight ?? baseStyle?.fontWeight,
    );
  }
}
