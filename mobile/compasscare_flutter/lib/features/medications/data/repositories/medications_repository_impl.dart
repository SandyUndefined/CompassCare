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

      rethrow;
    }
  }

  @override
  Future<MedicationModel> addMedication(CreateMedicationInput input) async {
    final created = await _remoteDataSource.addMedication(input);
    await _localDataSource.upsertCachedMedication(created);
    return created;
  }

  @override
  Future<MedicationModel> markMedicationTaken(int id) async {
    final updated = await _remoteDataSource.markMedicationTaken(id);
    await _localDataSource.upsertCachedMedication(updated);
    return updated;
  }

  @override
  Future<void> removeMedication(int id) async {
    await _remoteDataSource.removeMedication(id);
    await _localDataSource.deleteCachedMedication(id);
  }
}
