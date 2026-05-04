import 'package:compasscare_flutter/app/app.dart';
import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:compasscare_flutter/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';
import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';
import 'package:compasscare_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:compasscare_flutter/features/documents/domain/repositories/documents_repository.dart';
import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows onboarding and skip opens app shell', (
    WidgetTester tester,
  ) async {
    var onboardingCompleted = false;

    await tester.pumpWidget(
      CompassCareApp(
        config: const AppConfig(),
        apiClient: ApiClient(baseUrl: const AppConfig().apiBaseUrl),
        database: AppDatabase(),
        authRepository: _FakeAuthRepository(),
        medicationsRepository: _FakeMedicationsRepository(),
        appointmentsRepository: _FakeAppointmentsRepository(),
        documentsRepository: _FakeDocumentsRepository(),
        careTeamRepository: _FakeCareTeamRepository(),
        enableSplashScreen: false,
        onOnboardingCompleted: () async {
          onboardingCompleted = true;
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to CompassCare'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Medications'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.shopping_bag_outlined),
      ),
      findsOneWidget,
    );
    expect(onboardingCompleted, isTrue);
  });

  testWidgets('renders app shell tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      CompassCareApp(
        config: const AppConfig(),
        apiClient: ApiClient(baseUrl: const AppConfig().apiBaseUrl),
        database: AppDatabase(),
        authRepository: _FakeAuthRepository(),
        medicationsRepository: _FakeMedicationsRepository(),
        appointmentsRepository: _FakeAppointmentsRepository(),
        documentsRepository: _FakeDocumentsRepository(),
        careTeamRepository: _FakeCareTeamRepository(),
        enableSplashScreen: false,
        enableOnboardingScreen: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Medications'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.medication_outlined),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.calendar_month_outlined),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.folder_open_outlined),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.groups_outlined),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.shopping_bag_outlined),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.person_outline),
      ),
      findsOneWidget,
    );
  });

  testWidgets('opens shopping tab and renders shopping content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      CompassCareApp(
        config: const AppConfig(),
        apiClient: ApiClient(baseUrl: const AppConfig().apiBaseUrl),
        database: AppDatabase(),
        authRepository: _FakeAuthRepository(),
        medicationsRepository: _FakeMedicationsRepository(),
        appointmentsRepository: _FakeAppointmentsRepository(),
        documentsRepository: _FakeDocumentsRepository(),
        careTeamRepository: _FakeCareTeamRepository(),
        enableSplashScreen: false,
        enableOnboardingScreen: false,
      ),
    );

    await tester.tap(
      find.descendant(
        of: find.byType(DotNavigationBar),
        matching: find.byIcon(Icons.shopping_bag_outlined),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Care Supplies & Medications'), findsOneWidget);
    expect(find.text('Shop by Category'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  static const _user = AuthUserModel(
    id: 'user-1',
    name: 'Test User',
    email: 'test@example.com',
  );

  @override
  String? get currentToken => 'test-token';

  @override
  AuthUserModel? restoreUser() => _user;

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    return _user;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _user;
  }
}

class _FakeMedicationsRepository implements MedicationsRepository {
  @override
  Future<MedicationFetchResult> fetchMedications() async {
    return const MedicationFetchResult(
      medications: [],
      origin: MedicationDataOrigin.network,
    );
  }

  @override
  Future<MedicationModel> addMedication(CreateMedicationInput input) async {
    return const MedicationModel(
      id: 1,
      name: 'Sample',
      dosage: '10mg',
      frequency: 'Once daily',
      time: '8:00 AM',
      lastTaken: null,
      nextDue: null,
      critical: false,
    );
  }

  @override
  Future<MedicationModel> markMedicationTaken(int id) async {
    return const MedicationModel(
      id: 1,
      name: 'Sample',
      dosage: '10mg',
      frequency: 'Once daily',
      time: '8:00 AM',
      lastTaken: '8:00 AM - You',
      nextDue: null,
      critical: false,
    );
  }

  @override
  Future<void> removeMedication(int id) async {}
}

class _FakeAppointmentsRepository implements AppointmentsRepository {
  @override
  Future<AppointmentModel> addAppointment(CreateAppointmentInput input) async {
    return const AppointmentModel(
      id: 1,
      type: 'Primary Care',
      doctor: 'Dr. Smith',
      date: 'Mar 10, 2026',
      time: '10:00 AM',
      location: 'Family Health Center',
      assignedTo: 'Sarah',
      notes: 'Annual checkup',
    );
  }

  @override
  Future<AppointmentFetchResult> fetchAppointments() async {
    return const AppointmentFetchResult(
      appointments: [],
      origin: AppointmentDataOrigin.network,
    );
  }

  @override
  Future<void> removeAppointment(int id) async {}
}

class _FakeDocumentsRepository implements DocumentsRepository {
  @override
  Future<DocumentsFetchResult> fetchDocuments() async {
    return const DocumentsFetchResult(
      documents: <DocumentModel>[],
      origin: DocumentDataOrigin.network,
    );
  }
}

class _FakeCareTeamRepository implements CareTeamRepository {
  @override
  Future<CareTeamFetchResult> fetchCareTeamMembers() async {
    return const CareTeamFetchResult(
      members: <CareTeamMemberModel>[
        CareTeamMemberModel(
          id: 1,
          name: 'Sarah',
          role: 'Daughter',
          online: true,
          lastActive: null,
        ),
        CareTeamMemberModel(
          id: 2,
          name: 'Nurse Joy',
          role: 'Nurse',
          online: false,
          lastActive: '1h ago',
        ),
      ],
      origin: CareTeamDataOrigin.network,
    );
  }
}
