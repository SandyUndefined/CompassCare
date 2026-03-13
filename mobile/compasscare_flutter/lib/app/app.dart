import 'package:compasscare_flutter/app/theme/app_theme.dart';
import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/appointments/data/datasources/appointment_local_data_source.dart';
import 'package:compasscare_flutter/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:compasscare_flutter/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:compasscare_flutter/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:compasscare_flutter/features/care_team/data/datasources/care_team_local_data_source.dart';
import 'package:compasscare_flutter/features/care_team/data/datasources/care_team_remote_data_source.dart';
import 'package:compasscare_flutter/features/care_team/data/repositories/care_team_repository_impl.dart';
import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';
import 'package:compasscare_flutter/features/documents/data/datasources/document_local_data_source.dart';
import 'package:compasscare_flutter/features/documents/data/datasources/document_remote_data_source.dart';
import 'package:compasscare_flutter/features/documents/data/repositories/documents_repository_impl.dart';
import 'package:compasscare_flutter/features/documents/domain/repositories/documents_repository.dart';
import 'package:compasscare_flutter/features/medications/data/datasources/medication_local_data_source.dart';
import 'package:compasscare_flutter/features/medications/data/datasources/medication_remote_data_source.dart';
import 'package:compasscare_flutter/features/medications/data/repositories/medications_repository_impl.dart';
import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';
import 'package:compasscare_flutter/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:compasscare_flutter/features/shopping/data/repositories/shopping_repository_impl.dart';
import 'package:compasscare_flutter/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_header_cubit.dart';
import 'package:compasscare_flutter/features/shell/presentation/pages/app_shell_page.dart';
import 'package:compasscare_flutter/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splashscreen/splashscreen.dart';

class CompassCareApp extends StatelessWidget {
  const CompassCareApp({
    super.key,
    required this.config,
    required this.apiClient,
    required this.database,
    this.medicationsRepository,
    this.appointmentsRepository,
    this.documentsRepository,
    this.careTeamRepository,
    this.shoppingRepository,
    this.enableSplashScreen = true,
    this.enableOnboardingScreen = true,
    this.onOnboardingCompleted,
  });

  final AppConfig config;
  final ApiClient apiClient;
  final AppDatabase database;
  final MedicationsRepository? medicationsRepository;
  final AppointmentsRepository? appointmentsRepository;
  final DocumentsRepository? documentsRepository;
  final CareTeamRepository? careTeamRepository;
  final ShoppingRepository? shoppingRepository;
  final bool enableSplashScreen;
  final bool enableOnboardingScreen;
  final Future<void> Function()? onOnboardingCompleted;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppConfig>.value(value: config),
        RepositoryProvider<ApiClient>(
          create: (_) => apiClient,
          dispose: (client) => client.close(),
        ),
        RepositoryProvider<AppDatabase>(
          create: (_) => database,
          dispose: (db) {
            db.close();
          },
        ),
        if (medicationsRepository == null)
          RepositoryProvider<MedicationRemoteDataSource>(
            create: (context) => MedicationRemoteDataSource(
              apiClient: context.read<ApiClient>(),
            ),
          ),
        if (medicationsRepository == null)
          RepositoryProvider<MedicationLocalDataSource>(
            create: (context) => MedicationLocalDataSource(
              database: context.read<AppDatabase>(),
            ),
          ),
        if (medicationsRepository == null)
          RepositoryProvider<MedicationsRepository>(
            create: (context) => MedicationsRepositoryImpl(
              remoteDataSource: context.read<MedicationRemoteDataSource>(),
              localDataSource: context.read<MedicationLocalDataSource>(),
            ),
          ),
        if (medicationsRepository != null)
          RepositoryProvider<MedicationsRepository>.value(
            value: medicationsRepository!,
          ),
        if (appointmentsRepository == null)
          RepositoryProvider<AppointmentRemoteDataSource>(
            create: (context) => AppointmentRemoteDataSource(
              apiClient: context.read<ApiClient>(),
            ),
          ),
        if (appointmentsRepository == null)
          RepositoryProvider<AppointmentLocalDataSource>(
            create: (context) => AppointmentLocalDataSource(
              database: context.read<AppDatabase>(),
            ),
          ),
        if (appointmentsRepository == null)
          RepositoryProvider<AppointmentsRepository>(
            create: (context) => AppointmentsRepositoryImpl(
              remoteDataSource: context.read<AppointmentRemoteDataSource>(),
              localDataSource: context.read<AppointmentLocalDataSource>(),
            ),
          ),
        if (appointmentsRepository != null)
          RepositoryProvider<AppointmentsRepository>.value(
            value: appointmentsRepository!,
          ),
        if (documentsRepository == null)
          RepositoryProvider<DocumentRemoteDataSource>(
            create: (context) =>
                DocumentRemoteDataSource(apiClient: context.read<ApiClient>()),
          ),
        if (documentsRepository == null)
          RepositoryProvider<DocumentLocalDataSource>(
            create: (context) =>
                DocumentLocalDataSource(database: context.read<AppDatabase>()),
          ),
        if (documentsRepository == null)
          RepositoryProvider<DocumentsRepository>(
            create: (context) => DocumentsRepositoryImpl(
              remoteDataSource: context.read<DocumentRemoteDataSource>(),
              localDataSource: context.read<DocumentLocalDataSource>(),
            ),
          ),
        if (documentsRepository != null)
          RepositoryProvider<DocumentsRepository>.value(
            value: documentsRepository!,
          ),
        if (careTeamRepository == null)
          RepositoryProvider<CareTeamRemoteDataSource>(
            create: (context) =>
                CareTeamRemoteDataSource(apiClient: context.read<ApiClient>()),
          ),
        if (careTeamRepository == null)
          RepositoryProvider<CareTeamLocalDataSource>(
            create: (context) =>
                CareTeamLocalDataSource(database: context.read<AppDatabase>()),
          ),
        if (careTeamRepository == null)
          RepositoryProvider<CareTeamRepository>(
            create: (context) => CareTeamRepositoryImpl(
              remoteDataSource: context.read<CareTeamRemoteDataSource>(),
              localDataSource: context.read<CareTeamLocalDataSource>(),
            ),
          ),
        if (careTeamRepository != null)
          RepositoryProvider<CareTeamRepository>.value(
            value: careTeamRepository!,
          ),
        if (shoppingRepository == null)
          RepositoryProvider<ShoppingRepository>(
            create: (context) => ShoppingRepositoryImpl(
              medicationsRepository: context.read<MedicationsRepository>(),
            ),
          ),
        if (shoppingRepository != null)
          RepositoryProvider<ShoppingRepository>.value(
            value: shoppingRepository!,
          ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => ShellCubit()),
          BlocProvider(
            create: (context) => ShellHeaderCubit(
              repository: context.read<CareTeamRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDark = themeState.themeMode == ThemeMode.dark;
            final shortestSide = MediaQuery.sizeOf(context).shortestSide;
            final splashLogoSize = (shortestSide * 0.38).clamp(120.0, 180.0);
            final startupScreen = enableOnboardingScreen
                ? OnboardingPage(onCompleted: onOnboardingCompleted)
                : const AppShellPage();
            return MaterialApp(
              title: config.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeState.themeMode,
              home: enableSplashScreen
                  ? SplashScreen.timer(
                      seconds: 2,
                      navigateAfterSeconds: startupScreen,
                      image: Image.asset('assets/images/logo.png'),
                      photoSize: splashLogoSize,
                      backgroundColor: isDark
                          ? Colors.black
                          : Theme.of(context).colorScheme.surface,
                      loaderColor: isDark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      title: Text(
                        config.appName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      loadingText: const Text('Loading...'),
                    )
                  : startupScreen,
            );
          },
        ),
      ),
    );
  }
}
