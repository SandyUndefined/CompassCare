import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6367FF);
  static const _secondaryColor = Color(0xFF8494FF);
  static const _tertiaryColor = Color(0xFFC9BEFF);
  static const _accentContainerColor = Color(0xFFFFDBFD);
  static const _primaryFontFamily = 'Merriweather';
  static const _secondaryFontFamily = 'NotoSans';

  static ThemeData light() {
    final colorScheme = _lightColorScheme;
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
    final colorScheme = _darkColorScheme;
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

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: _primaryColor,
        onPrimary: Colors.white,
        primaryContainer: _tertiaryColor,
        onPrimaryContainer: const Color(0xFF1A1B4A),
        secondary: _secondaryColor,
        onSecondary: const Color(0xFF131632),
        secondaryContainer: _accentContainerColor,
        onSecondaryContainer: const Color(0xFF3E2B49),
        tertiary: _tertiaryColor,
        onTertiary: const Color(0xFF1A1B4A),
        tertiaryContainer: _accentContainerColor,
        onTertiaryContainer: const Color(0xFF3E2B49),
        surface: const Color(0xFFF7F6FF),
        onSurface: const Color(0xFF1D1C2A),
        onSurfaceVariant: const Color(0xFF535070),
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _secondaryColor,
        onPrimary: const Color(0xFF14152A),
        primaryContainer: const Color(0xFF4A4ED1),
        onPrimaryContainer: const Color(0xFFF0EEFF),
        secondary: _tertiaryColor,
        onSecondary: const Color(0xFF1D1B2E),
        secondaryContainer: const Color(0xFF6F65B6),
        onSecondaryContainer: const Color(0xFFF5EEFF),
        tertiary: _accentContainerColor,
        onTertiary: const Color(0xFF2A1C35),
        tertiaryContainer: const Color(0xFF8E72A6),
        onTertiaryContainer: const Color(0xFFFFF3FF),
        surface: const Color(0xFF12131D),
        onSurface: const Color(0xFFE9E7F7),
        onSurfaceVariant: const Color(0xFFC8C3E5),
      );
}
