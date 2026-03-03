part of 'care_team_bloc.dart';

sealed class CareTeamEvent extends Equatable {
  const CareTeamEvent();

  @override
  List<Object?> get props => [];
}

class CareTeamRequested extends CareTeamEvent {
  const CareTeamRequested();
}

class CareTeamRefreshed extends CareTeamEvent {
  const CareTeamRefreshed();
}

class CareTeamNoticeCleared extends CareTeamEvent {
  const CareTeamNoticeCleared();
}
