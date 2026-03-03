part of 'care_team_bloc.dart';

enum CareTeamStatus { initial, loading, success, failure }

enum CareTeamNoticeType { success, error }

class CareTeamNotice extends Equatable {
  const CareTeamNotice({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final CareTeamNoticeType type;

  @override
  List<Object?> get props => [id, message, type];
}

class CareTeamState extends Equatable {
  const CareTeamState({
    this.status = CareTeamStatus.initial,
    this.members = const [],
    this.isRefreshing = false,
    this.isFromCache = false,
    this.notice,
  });

  final CareTeamStatus status;
  final List<CareTeamMemberModel> members;
  final bool isRefreshing;
  final bool isFromCache;
  final CareTeamNotice? notice;

  bool get isInitialLoading =>
      status == CareTeamStatus.loading && members.isEmpty;

  CareTeamState copyWith({
    CareTeamStatus? status,
    List<CareTeamMemberModel>? members,
    bool? isRefreshing,
    bool? isFromCache,
    CareTeamNotice? notice,
    bool clearNotice = false,
  }) {
    return CareTeamState(
      status: status ?? this.status,
      members: members ?? this.members,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [
    status,
    members,
    isRefreshing,
    isFromCache,
    notice,
  ];
}
