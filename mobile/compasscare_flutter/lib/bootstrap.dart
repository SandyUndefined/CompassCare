import 'package:compasscare_flutter/app/app.dart';
import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _hasSeenOnboardingPreferenceKey = 'has_seen_onboarding';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = AppConfig();
  final database = AppDatabase();
  final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
  final preferences = await SharedPreferences.getInstance();
  final hasSeenOnboarding =
      preferences.getBool(_hasSeenOnboardingPreferenceKey) ?? false;

  runApp(
    CompassCareApp(
      config: config,
      apiClient: apiClient,
      database: database,
      enableOnboardingScreen: !hasSeenOnboarding,
      onOnboardingCompleted: () async {
        await preferences.setBool(_hasSeenOnboardingPreferenceKey, true);
      },
    ),
  );
}
