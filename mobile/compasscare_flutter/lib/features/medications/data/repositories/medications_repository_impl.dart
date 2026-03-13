import 'package:compasscare_flutter/core/data/bundled_care_data.dart';
import 'package:compasscare_flutter/features/medications/data/datasources/medication_local_data_source.dart';
import 'package:compasscare_flutter/features/medications/data/datasources/medication_remote_data_source.dart';
import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';

class MedicationsRepositoryImpl implements MedicationsRepository {
  const MedicationsRepositoryImpl({
    required MedicationRemoteDataSource remoteDataSource,
    required MedicationLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final MedicationRemoteDataSource _remoteDataSource;
  final MedicationLocalDataSource _localDataSource;

  @override
  Future<MedicationFetchResult> fetchMedications() async {
    try {
      final medications = await _remoteDataSource.fetchMedications();
      await _localDataSource.replaceCachedMedications(medications);

      return MedicationFetchResult(
        medications: medications,
        origin: MedicationDataOrigin.network,
      );
    } catch (_) {
      final cached = await _localDataSource.fetchCachedMedications();
      if (cached.isNotEmpty) {
        return MedicationFetchResult(
          medications: cached,
          origin: MedicationDataOrigin.cache,
        );
      }

      await _localDataSource.replaceCachedMedications(
        BundledCareData.medications,
      );
      return const MedicationFetchResult(
        medications: BundledCareData.medications,
        origin: MedicationDataOrigin.cache,
      );
    }
  }

  @override
  Future<MedicationModel> addMedication(CreateMedicationInput input) async {
    try {
      final created = await _remoteDataSource.addMedication(input);
      await _localDataSource.upsertCachedMedication(created);
      return created;
    } catch (_) {
      final created = MedicationModel(
        id: await _localDataSource.nextLocalMedicationId(),
        name: input.name,
        dosage: input.dosage,
        frequency: input.frequency,
        time: input.time,
        lastTaken: null,
        nextDue: null,
        critical: input.critical,
      );
      await _localDataSource.upsertCachedMedication(created);
      return created;
    }
  }

  @override
  Future<MedicationModel> markMedicationTaken(int id) async {
    try {
      final updated = await _remoteDataSource.markMedicationTaken(id);
      await _localDataSource.upsertCachedMedication(updated);
      return updated;
    } catch (_) {
      final cached = await _localDataSource.fetchCachedMedications();
      final target = cached.where((item) => item.id == id).firstOrNull;
      if (target == null) {
        rethrow;
      }

      final now = DateTime.now();
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? 'PM' : 'AM';
      final updated = MedicationModel(
        id: target.id,
        name: target.name,
        dosage: target.dosage,
        frequency: target.frequency,
        time: target.time,
        lastTaken: '$hour:$minute $period - You',
        nextDue: target.nextDue,
        critical: target.critical,
      );
      await _localDataSource.upsertCachedMedication(updated);
      return updated;
    }
  }

  @override
  Future<void> removeMedication(int id) async {
    try {
      await _remoteDataSource.removeMedication(id);
    } finally {
      await _localDataSource.deleteCachedMedication(id);
    }
  }
}
