import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ShellHeaderStatus { initial, loading, success, failure }

class ShellHeaderState extends Equatable {
  const ShellHeaderState({
    this.status = ShellHeaderStatus.initial,
    this.members = const [],
    this.isFromCache = false,
  });

  final ShellHeaderStatus status;
  final List<CareTeamMemberModel> members;
  final bool isFromCache;

  ShellHeaderState copyWith({
    ShellHeaderStatus? status,
    List<CareTeamMemberModel>? members,
    bool? isFromCache,
  }) {
    return ShellHeaderState(
      status: status ?? this.status,
      members: members ?? this.members,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }

  @override
  List<Object?> get props => [status, members, isFromCache];
}

class ShellHeaderCubit extends Cubit<ShellHeaderState> {
  ShellHeaderCubit({required CareTeamRepository repository})
    : _repository = repository,
      super(const ShellHeaderState());

  final CareTeamRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: ShellHeaderStatus.loading));

    try {
      final result = await _repository.fetchCareTeamMembers();
      final sorted = [...result.members]
        ..sort((a, b) {
          if (a.online == b.online) {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          return a.online ? -1 : 1;
        });

      emit(
        state.copyWith(
          status: ShellHeaderStatus.success,
          members: sorted,
          isFromCache: result.origin == CareTeamDataOrigin.cache,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ShellHeaderStatus.failure));
    }
  }
}
