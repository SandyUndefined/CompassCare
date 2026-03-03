class AppConfig {
  const AppConfig();

  static const String _defaultApiBaseUrl =
      'https://asset-linker-graziellevoller.replit.app';
  static const String _configuredApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );

  String get appName => 'CompassCare';
  String get apiBaseUrl => _configuredApiBaseUrl;
}
