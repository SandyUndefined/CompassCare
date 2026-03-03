part of 'medications_bloc.dart';

sealed class MedicationsEvent extends Equatable {
  const MedicationsEvent();

  @override
  List<Object?> get props => [];
}

class MedicationsRequested extends MedicationsEvent {
  const MedicationsRequested();
}

class MedicationsRefreshed extends MedicationsEvent {
  const MedicationsRefreshed();
}

class MedicationsAddRequested extends MedicationsEvent {
  const MedicationsAddRequested(this.input);

  final CreateMedicationInput input;

  @override
  List<Object?> get props => [input];
}

class MedicationMarkTakenRequested extends MedicationsEvent {
  const MedicationMarkTakenRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MedicationRemoveRequested extends MedicationsEvent {
  const MedicationRemoveRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MedicationsNoticeCleared extends MedicationsEvent {
  const MedicationsNoticeCleared();
}
