import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'care_team_event.dart';
part 'care_team_state.dart';

class CareTeamBloc extends Bloc<CareTeamEvent, CareTeamState> {
  CareTeamBloc({required CareTeamRepository repository})
    : _repository = repository,
      super(const CareTeamState()) {
    on<CareTeamRequested>(_onCareTeamRequested);
    on<CareTeamRefreshed>(_onCareTeamRefreshed);
    on<CareTeamNoticeCleared>(_onCareTeamNoticeCleared);
  }

  final CareTeamRepository _repository;
  int _noticeCounter = 0;

  Future<void> _onCareTeamRequested(
    CareTeamRequested event,
    Emitter<CareTeamState> emit,
  ) async {
    await _fetchCareTeam(emit, isRefresh: false);
  }

  Future<void> _onCareTeamRefreshed(
    CareTeamRefreshed event,
    Emitter<CareTeamState> emit,
  ) async {
    await _fetchCareTeam(emit, isRefresh: true);
  }

  Future<void> _fetchCareTeam(
    Emitter<CareTeamState> emit, {
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearNotice: true));
    } else {
      emit(state.copyWith(status: CareTeamStatus.loading, clearNotice: true));
    }

    try {
      final result = await _repository.fetchCareTeamMembers();
      emit(
        state.copyWith(
          status: CareTeamStatus.success,
          members: result.members,
          isFromCache: result.origin == CareTeamDataOrigin.cache,
          isRefreshing: false,
          clearNotice: true,
        ),
      );
    } catch (_) {
      if (state.members.isNotEmpty) {
        emit(
          state.copyWith(
            isRefreshing: false,
            notice: _createNotice(
              type: CareTeamNoticeType.error,
              message: 'Unable to refresh care team right now.',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CareTeamStatus.failure,
            isRefreshing: false,
            notice: _createNotice(
              type: CareTeamNoticeType.error,
              message: 'Unable to load care team. Please try again.',
            ),
          ),
        );
      }
    }
  }

  void _onCareTeamNoticeCleared(
    CareTeamNoticeCleared event,
    Emitter<CareTeamState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }

  CareTeamNotice _createNotice({
    required CareTeamNoticeType type,
    required String message,
  }) {
    _noticeCounter += 1;
    return CareTeamNotice(id: _noticeCounter, message: message, type: type);
  }
}
