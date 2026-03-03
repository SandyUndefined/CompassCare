import 'dart:convert';

import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:compasscare_flutter/features/medications/domain/repositories/medications_repository.dart';

class MedicationRemoteDataSource {
  const MedicationRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<MedicationModel>> fetchMedications() async {
    final response = await _apiClient.get('/api/medications');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch medications (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Unexpected medications response format');
    }

    return decoded
        .map((item) => MedicationModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<MedicationModel> addMedication(CreateMedicationInput input) async {
    final response = await _apiClient.post(
      '/api/medications',
      body: input.toJson(),
    );

    return _decodeMedicationResponse(
      response.statusCode,
      response.body,
      expectedStatus: 201,
      actionLabel: 'add medication',
    );
  }

  Future<MedicationModel> markMedicationTaken(int id) async {
    final response = await _apiClient.patch('/api/medications/$id/taken');

    return _decodeMedicationResponse(
      response.statusCode,
      response.body,
      expectedStatus: 200,
      actionLabel: 'mark medication as taken',
    );
  }

  Future<void> removeMedication(int id) async {
    final response = await _apiClient.delete('/api/medications/$id');
    if (response.statusCode != 204) {
      throw Exception(
        'Failed to delete medication (status: ${response.statusCode})',
      );
    }
  }

  MedicationModel _decodeMedicationResponse(
    int statusCode,
    String body, {
    required int expectedStatus,
    required String actionLabel,
  }) {
    if (statusCode != expectedStatus) {
      throw Exception('Failed to $actionLabel (status: $statusCode)');
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException(
        'Unexpected response format when trying to $actionLabel',
      );
    }

    return MedicationModel.fromJson(decoded);
  }
}
