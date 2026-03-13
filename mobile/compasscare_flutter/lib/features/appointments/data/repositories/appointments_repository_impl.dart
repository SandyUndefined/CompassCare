import 'package:compasscare_flutter/core/data/bundled_care_data.dart';
import 'package:compasscare_flutter/features/appointments/data/datasources/appointment_local_data_source.dart';
import 'package:compasscare_flutter/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:compasscare_flutter/features/appointments/domain/repositories/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  const AppointmentsRepositoryImpl({
    required AppointmentRemoteDataSource remoteDataSource,
    required AppointmentLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AppointmentRemoteDataSource _remoteDataSource;
  final AppointmentLocalDataSource _localDataSource;

  @override
  Future<AppointmentFetchResult> fetchAppointments() async {
    try {
      final appointments = await _remoteDataSource.fetchAppointments();
      await _localDataSource.replaceCachedAppointments(appointments);

      return AppointmentFetchResult(
        appointments: appointments,
        origin: AppointmentDataOrigin.network,
      );
    } catch (_) {
      final cached = await _localDataSource.fetchCachedAppointments();
      if (cached.isNotEmpty) {
        return AppointmentFetchResult(
          appointments: cached,
          origin: AppointmentDataOrigin.cache,
        );
      }

      await _localDataSource.replaceCachedAppointments(
        BundledCareData.appointments,
      );
      return const AppointmentFetchResult(
        appointments: BundledCareData.appointments,
        origin: AppointmentDataOrigin.cache,
      );
    }
  }

  @override
  Future<AppointmentModel> addAppointment(CreateAppointmentInput input) async {
    try {
      final created = await _remoteDataSource.addAppointment(input);
      await _localDataSource.upsertCachedAppointment(created);
      return created;
    } catch (_) {
      final created = AppointmentModel(
        id: await _localDataSource.nextLocalAppointmentId(),
        type: input.type,
        doctor: input.doctor,
        date: input.date,
        time: input.time,
        location: input.location,
        assignedTo: input.assignedTo,
        notes: input.notes,
      );
      await _localDataSource.upsertCachedAppointment(created);
      return created;
    }
  }

  @override
  Future<void> removeAppointment(int id) async {
    try {
      await _remoteDataSource.removeAppointment(id);
    } finally {
      await _localDataSource.deleteCachedAppointment(id);
    }
  }
}
