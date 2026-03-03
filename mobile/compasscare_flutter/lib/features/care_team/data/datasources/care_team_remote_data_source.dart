import 'dart:convert';

import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';

class CareTeamRemoteDataSource {
  const CareTeamRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<CareTeamMemberModel>> fetchCareTeamMembers() async {
    final response = await _apiClient.get('/api/care-team');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch care team (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Unexpected care team response format');
    }

    return decoded
        .map(
          (item) => CareTeamMemberModel.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }
}
