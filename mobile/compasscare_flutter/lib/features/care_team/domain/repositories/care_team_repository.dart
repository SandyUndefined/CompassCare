import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:equatable/equatable.dart';

enum CareTeamDataOrigin { network, cache }

class CareTeamFetchResult extends Equatable {
  const CareTeamFetchResult({required this.members, required this.origin});

  final List<CareTeamMemberModel> members;
  final CareTeamDataOrigin origin;

  @override
  List<Object?> get props => [members, origin];
}

abstract class CareTeamRepository {
  Future<CareTeamFetchResult> fetchCareTeamMembers();
}
