import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:compasscare_flutter/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  AppointmentsBloc({required AppointmentsRepository repository})
    : _repository = repository,
      super(const AppointmentsState()) {
    on<AppointmentsRequested>(_onAppointmentsRequested);
    on<AppointmentsRefreshed>(_onAppointmentsRefreshed);
    on<AppointmentsAddRequested>(_onAppointmentsAddRequested);
    on<AppointmentRemoveRequested>(_onAppointmentRemoveRequested);
    on<AppointmentsNoticeCleared>(_onAppointmentsNoticeCleared);
  }

  final AppointmentsRepository _repository;
  int _noticeCounter = 0;

  Future<void> _onAppointmentsRequested(
    AppointmentsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    await _fetchAppointments(emit, isRefresh: false);
  }

  Future<void> _onAppointmentsRefreshed(
    AppointmentsRefreshed event,
    Emitter<AppointmentsState> emit,
  ) async {
    await _fetchAppointments(emit, isRefresh: true);
  }

  Future<void> _fetchAppointments(
    Emitter<AppointmentsState> emit, {
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearNotice: true));
    } else {
      emit(
        state.copyWith(status: AppointmentsStatus.loading, clearNotice: true),
      );
    }

    try {
      final result = await _repository.fetchAppointments();
      emit(
        state.copyWith(
          status: AppointmentsStatus.success,
          appointments: result.appointments,
          isFromCache: result.origin == AppointmentDataOrigin.cache,
          isRefreshing: false,
          clearNotice: true,
        ),
      );
    } catch (_) {
      if (state.appointments.isNotEmpty) {
        emit(
          state.copyWith(
            isRefreshing: false,
            notice: _createNotice(
              type: AppointmentsNoticeType.error,
              message: 'Unable to refresh appointments right now.',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AppointmentsStatus.failure,
            isRefreshing: false,
            notice: _createNotice(
              type: AppointmentsNoticeType.error,
              message: 'Unable to load appointments. Please try again.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _onAppointmentsAddRequested(
    AppointmentsAddRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    if (state.isAddingAppointment) {
      return;
    }

    emit(state.copyWith(isAddingAppointment: true, clearNotice: true));

    try {
      final created = await _repository.addAppointment(event.input);
      final updatedAppointments = [created, ..._withoutAppointment(created.id)];

      emit(
        state.copyWith(
          status: AppointmentsStatus.success,
          appointments: updatedAppointments,
          isAddingAppointment: false,
          isFromCache: false,
          notice: _createNotice(
            type: AppointmentsNoticeType.success,
            message: 'Appointment added successfully.',
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isAddingAppointment: false,
          notice: _createNotice(
            type: AppointmentsNoticeType.error,
            message: 'Unable to add appointment right now.',
          ),
        ),
      );
    }
  }

  Future<void> _onAppointmentRemoveRequested(
    AppointmentRemoveRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    if (state.isRemovingAppointment(event.id)) {
      return;
    }

    emit(
      state.copyWith(
        removingAppointmentIds: [...state.removingAppointmentIds, event.id],
        clearNotice: true,
      ),
    );

    try {
      await _repository.removeAppointment(event.id);
      emit(
        state.copyWith(
          appointments: _withoutAppointment(event.id),
          removingAppointmentIds: _removeIdFromList(
            state.removingAppointmentIds,
            event.id,
          ),
          isFromCache: false,
          notice: _createNotice(
            type: AppointmentsNoticeType.success,
            message: 'Appointment removed.',
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          removingAppointmentIds: _removeIdFromList(
            state.removingAppointmentIds,
            event.id,
          ),
          notice: _createNotice(
            type: AppointmentsNoticeType.error,
            message: 'Unable to remove appointment right now.',
          ),
        ),
      );
    }
  }

  void _onAppointmentsNoticeCleared(
    AppointmentsNoticeCleared event,
    Emitter<AppointmentsState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }

  List<AppointmentModel> _withoutAppointment(int id) {
    return state.appointments
        .where((item) => item.id != id)
        .toList(growable: false);
  }

  List<int> _removeIdFromList(List<int> source, int id) {
    return source.where((item) => item != id).toList(growable: false);
  }

  AppointmentsNotice _createNotice({
    required AppointmentsNoticeType type,
    required String message,
  }) {
    _noticeCounter += 1;
    return AppointmentsNotice(id: _noticeCounter, message: message, type: type);
  }
}
