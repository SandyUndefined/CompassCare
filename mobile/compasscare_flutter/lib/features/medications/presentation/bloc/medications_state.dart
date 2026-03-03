part of 'medications_bloc.dart';

enum MedicationsStatus { initial, loading, success, failure }

enum MedicationsNoticeType { success, error }

class MedicationsNotice extends Equatable {
  const MedicationsNotice({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final MedicationsNoticeType type;

  @override
  List<Object?> get props => [id, message, type];
}

class MedicationsState extends Equatable {
  const MedicationsState({
    this.status = MedicationsStatus.initial,
    this.medications = const [],
    this.isRefreshing = false,
    this.isFromCache = false,
    this.isAddingMedication = false,
    this.takingMedicationIds = const [],
    this.removingMedicationIds = const [],
    this.notice,
  });

  final MedicationsStatus status;
  final List<MedicationModel> medications;
  final bool isRefreshing;
  final bool isFromCache;
  final bool isAddingMedication;
  final List<int> takingMedicationIds;
  final List<int> removingMedicationIds;
  final MedicationsNotice? notice;

  bool get isInitialLoading =>
      status == MedicationsStatus.loading && medications.isEmpty;

  bool isTakingMedication(int id) => takingMedicationIds.contains(id);

  bool isRemovingMedication(int id) => removingMedicationIds.contains(id);

  MedicationsState copyWith({
    MedicationsStatus? status,
    List<MedicationModel>? medications,
    bool? isRefreshing,
    bool? isFromCache,
    bool? isAddingMedication,
    List<int>? takingMedicationIds,
    List<int>? removingMedicationIds,
    MedicationsNotice? notice,
    bool clearNotice = false,
  }) {
    return MedicationsState(
      status: status ?? this.status,
      medications: medications ?? this.medications,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      isAddingMedication: isAddingMedication ?? this.isAddingMedication,
      takingMedicationIds: takingMedicationIds ?? this.takingMedicationIds,
      removingMedicationIds:
          removingMedicationIds ?? this.removingMedicationIds,
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [
    status,
    medications,
    isRefreshing,
    isFromCache,
    isAddingMedication,
    takingMedicationIds,
    removingMedicationIds,
    notice,
  ];
}
