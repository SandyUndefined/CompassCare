import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:equatable/equatable.dart';

enum MedicationDataOrigin { network, cache }

class MedicationFetchResult extends Equatable {
  const MedicationFetchResult({
    required this.medications,
    required this.origin,
  });

  final List<MedicationModel> medications;
  final MedicationDataOrigin origin;

  @override
  List<Object?> get props => [medications, origin];
}

class CreateMedicationInput extends Equatable {
  const CreateMedicationInput({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    this.critical = false,
  });

  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final bool critical;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'lastTaken': null,
      'nextDue': null,
      'critical': critical,
    };
  }

  @override
  List<Object?> get props => [name, dosage, frequency, time, critical];
}

abstract class MedicationsRepository {
  Future<MedicationFetchResult> fetchMedications();
  Future<MedicationModel> addMedication(CreateMedicationInput input);
  Future<MedicationModel> markMedicationTaken(int id);
  Future<void> removeMedication(int id);
}
