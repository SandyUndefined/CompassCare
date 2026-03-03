import 'package:compasscare_flutter/features/care_team/data/datasources/care_team_local_data_source.dart';
import 'package:compasscare_flutter/features/care_team/data/datasources/care_team_remote_data_source.dart';
import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';

class CareTeamRepositoryImpl implements CareTeamRepository {
  const CareTeamRepositoryImpl({
    required CareTeamRemoteDataSource remoteDataSource,
    required CareTeamLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final CareTeamRemoteDataSource _remoteDataSource;
  final CareTeamLocalDataSource _localDataSource;

  @override
  Future<CareTeamFetchResult> fetchCareTeamMembers() async {
    try {
      final members = await _remoteDataSource.fetchCareTeamMembers();
      await _localDataSource.replaceCachedCareTeamMembers(members);

      return CareTeamFetchResult(
        members: members,
        origin: CareTeamDataOrigin.network,
      );
    } catch (_) {
      final cached = await _localDataSource.fetchCachedCareTeamMembers();
      if (cached.isNotEmpty) {
        return CareTeamFetchResult(
          members: cached,
          origin: CareTeamDataOrigin.cache,
        );
      }

      rethrow;
    }
  }
}
