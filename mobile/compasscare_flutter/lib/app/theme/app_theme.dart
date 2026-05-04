import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF4F46E5);
  static const _secondaryColor = Color(0xFF0F766E);
  static const _tertiaryColor = Color(0xFFF97316);
  static const _primaryFontFamily = 'StackSansHeadline';
  static const _secondaryFontFamily = 'Roboto';

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
      cardTheme: _cardTheme(colorScheme),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      filledButtonTheme: _filledButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      iconButtonTheme: _iconButtonTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
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
      cardTheme: _cardTheme(colorScheme),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      filledButtonTheme: _filledButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      iconButtonTheme: _iconButtonTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
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

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );
  }

  static ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      iconColor: colorScheme.onSurfaceVariant,
      minTileHeight: 56,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  static IconButtonThemeData _iconButtonTheme(ColorScheme colorScheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurfaceVariant,
        highlightColor: colorScheme.primary.withAlpha(18),
      ),
    );
  }

  static final ColorScheme _lightColorScheme =
      ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: _primaryColor,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFE0E7FF),
        onPrimaryContainer: const Color(0xFF1E1B4B),
        secondary: _secondaryColor,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFCCFBF1),
        onSecondaryContainer: const Color(0xFF134E4A),
        tertiary: _tertiaryColor,
        onTertiary: Colors.white,
        tertiaryContainer: const Color(0xFFFFEDD5),
        onTertiaryContainer: const Color(0xFF7C2D12),
        surface: const Color(0xFFF8FAFC),
        surfaceContainerLow: Colors.white,
        surfaceContainerHighest: const Color(0xFFEFF2F7),
        onSurface: const Color(0xFF111827),
        onSurfaceVariant: const Color(0xFF64748B),
        outlineVariant: const Color(0xFFE2E8F0),
      );

  static final ColorScheme _darkColorScheme =
      ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _secondaryColor,
        onPrimary: const Color(0xFF14152A),
        primaryContainer: const Color(0xFF1E3A8A),
        onPrimaryContainer: const Color(0xFFE0E7FF),
        secondary: const Color(0xFF5EEAD4),
        onSecondary: const Color(0xFF042F2E),
        secondaryContainer: const Color(0xFF134E4A),
        onSecondaryContainer: const Color(0xFFCCFBF1),
        tertiary: const Color(0xFFFDBA74),
        onTertiary: const Color(0xFF431407),
        tertiaryContainer: const Color(0xFF7C2D12),
        onTertiaryContainer: const Color(0xFFFFEDD5),
        surface: const Color(0xFF0F172A),
        surfaceContainerLow: const Color(0xFF111827),
        surfaceContainerHighest: const Color(0xFF1F2937),
        onSurface: const Color(0xFFF8FAFC),
        onSurfaceVariant: const Color(0xFFCBD5E1),
        outlineVariant: const Color(0xFF263244),
      );
}
