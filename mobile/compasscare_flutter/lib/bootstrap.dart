import 'package:compasscare_flutter/app/app.dart';
import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:compasscare_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:compasscare_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:compasscare_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _hasSeenOnboardingPreferenceKey = 'has_seen_onboarding';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = AppConfig();
  final database = AppDatabase();
  late final AuthRepository authRepository;
  final apiClient = ApiClient(
    baseUrl: config.apiBaseUrl,
    authTokenProvider: () => authRepository.currentToken,
  );
  final preferences = await SharedPreferences.getInstance();
  authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient: apiClient),
    localDataSource: AuthLocalDataSource(preferences: preferences),
  );
  final hasSeenOnboarding =
      preferences.getBool(_hasSeenOnboardingPreferenceKey) ?? false;

  runApp(
    CompassCareApp(
      config: config,
      apiClient: apiClient,
      database: database,
      authRepository: authRepository,
      enableOnboardingScreen: !hasSeenOnboarding,
      onOnboardingCompleted: () async {
        await preferences.setBool(_hasSeenOnboardingPreferenceKey, true);
      },
    ),
  );
}
