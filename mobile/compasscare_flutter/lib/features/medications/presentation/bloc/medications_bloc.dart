import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'medications_event.dart';
part 'medications_state.dart';

class MedicationsBloc extends Bloc<MedicationsEvent, MedicationsState> {
  MedicationsBloc({required MedicationsRepository repository})
    : _repository = repository,
      super(const MedicationsState()) {
    on<MedicationsRequested>(_onMedicationsRequested);
    on<MedicationsRefreshed>(_onMedicationsRefreshed);
    on<MedicationsAddRequested>(_onMedicationsAddRequested);
    on<MedicationMarkTakenRequested>(_onMedicationMarkTakenRequested);
    on<MedicationRemoveRequested>(_onMedicationRemoveRequested);
    on<MedicationsNoticeCleared>(_onMedicationsNoticeCleared);
  }

  final MedicationsRepository _repository;
  int _noticeCounter = 0;

  Future<void> _onMedicationsRequested(
    MedicationsRequested event,
    Emitter<MedicationsState> emit,
  ) async {
    await _fetchMedications(emit, isRefresh: false);
  }

  Future<void> _onMedicationsRefreshed(
    MedicationsRefreshed event,
    Emitter<MedicationsState> emit,
  ) async {
    await _fetchMedications(emit, isRefresh: true);
  }

  Future<void> _fetchMedications(
    Emitter<MedicationsState> emit, {
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearNotice: true));
    } else {
      emit(
        state.copyWith(status: MedicationsStatus.loading, clearNotice: true),
      );
    }

    try {
      final result = await _repository.fetchMedications();
      emit(
        state.copyWith(
          status: MedicationsStatus.success,
          medications: result.medications,
          isFromCache: result.origin == MedicationDataOrigin.cache,
          isRefreshing: false,
          clearNotice: true,
        ),
      );
    } catch (_) {
      if (state.medications.isNotEmpty) {
        emit(
          state.copyWith(
            isRefreshing: false,
            notice: _createNotice(
              type: MedicationsNoticeType.error,
              message: 'Unable to refresh medications right now.',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: MedicationsStatus.failure,
            isRefreshing: false,
            notice: _createNotice(
              type: MedicationsNoticeType.error,
              message:
                  'Unable to load medications. Check API connection and try again.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _onMedicationsAddRequested(
    MedicationsAddRequested event,
    Emitter<MedicationsState> emit,
  ) async {
    if (state.isAddingMedication) {
      return;
    }

    emit(state.copyWith(isAddingMedication: true, clearNotice: true));

    try {
      final created = await _repository.addMedication(event.input);
      final updatedMedications = [created, ..._withoutMedication(created.id)];

      emit(
        state.copyWith(
          status: MedicationsStatus.success,
          medications: updatedMedications,
          isAddingMedication: false,
          isFromCache: false,
          notice: _createNotice(
            type: MedicationsNoticeType.success,
            message: 'Medication added successfully.',
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isAddingMedication: false,
          notice: _createNotice(
            type: MedicationsNoticeType.error,
            message: 'Unable to add medication right now.',
          ),
        ),
      );
    }
  }

  Future<void> _onMedicationMarkTakenRequested(
    MedicationMarkTakenRequested event,
    Emitter<MedicationsState> emit,
  ) async {
    if (state.isTakingMedication(event.id)) {
      return;
    }

    emit(
      state.copyWith(
        takingMedicationIds: [...state.takingMedicationIds, event.id],
        clearNotice: true,
      ),
    );

    try {
      final updated = await _repository.markMedicationTaken(event.id);
      emit(
        state.copyWith(
          medications: _replaceMedication(updated),
          takingMedicationIds: _removeIdFromList(
            state.takingMedicationIds,
            event.id,
          ),
          isFromCache: false,
          notice: _createNotice(
            type: MedicationsNoticeType.success,
            message: 'Medication marked as taken.',
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          takingMedicationIds: _removeIdFromList(
            state.takingMedicationIds,
            event.id,
          ),
          notice: _createNotice(
            type: MedicationsNoticeType.error,
            message: 'Unable to mark medication as taken.',
          ),
        ),
      );
    }
  }

  Future<void> _onMedicationRemoveRequested(
    MedicationRemoveRequested event,
    Emitter<MedicationsState> emit,
  ) async {
    if (state.isRemovingMedication(event.id)) {
      return;
    }

    emit(
      state.copyWith(
        removingMedicationIds: [...state.removingMedicationIds, event.id],
        clearNotice: true,
      ),
    );

    try {
      await _repository.removeMedication(event.id);
      emit(
        state.copyWith(
          medications: _withoutMedication(event.id),
          removingMedicationIds: _removeIdFromList(
            state.removingMedicationIds,
            event.id,
          ),
          isFromCache: false,
          notice: _createNotice(
            type: MedicationsNoticeType.success,
            message: 'Medication removed.',
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          removingMedicationIds: _removeIdFromList(
            state.removingMedicationIds,
            event.id,
          ),
          notice: _createNotice(
            type: MedicationsNoticeType.error,
            message: 'Unable to remove medication right now.',
          ),
        ),
      );
    }
  }

  void _onMedicationsNoticeCleared(
    MedicationsNoticeCleared event,
    Emitter<MedicationsState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }

  List<MedicationModel> _replaceMedication(MedicationModel updatedMedication) {
    final updatedList = [...state.medications];
    final targetIndex = updatedList.indexWhere(
      (item) => item.id == updatedMedication.id,
    );
    if (targetIndex == -1) {
      updatedList.insert(0, updatedMedication);
      return updatedList;
    }

    updatedList[targetIndex] = updatedMedication;
    return updatedList;
  }

  List<MedicationModel> _withoutMedication(int id) {
    return state.medications
        .where((item) => item.id != id)
        .toList(growable: false);
  }

  List<int> _removeIdFromList(List<int> source, int id) {
    return source.where((item) => item != id).toList(growable: false);
  }

  MedicationsNotice _createNotice({
    required MedicationsNoticeType type,
    required String message,
  }) {
    _noticeCounter += 1;
    return MedicationsNotice(id: _noticeCounter, message: message, type: type);
  }
}
