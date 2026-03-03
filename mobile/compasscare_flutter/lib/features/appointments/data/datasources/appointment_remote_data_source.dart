import 'dart:convert';

import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:compasscare_flutter/features/appointments/domain/repositories/appointments_repository.dart';

class AppointmentRemoteDataSource {
  const AppointmentRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<AppointmentModel>> fetchAppointments() async {
    final response = await _apiClient.get('/api/appointments');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch appointments (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Unexpected appointments response format');
    }

    return decoded
        .map((item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<AppointmentModel> addAppointment(CreateAppointmentInput input) async {
    final response = await _apiClient.post(
      '/api/appointments',
      body: input.toJson(),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to add appointment (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected add appointment response format');
    }

    return AppointmentModel.fromJson(decoded);
  }

  Future<void> removeAppointment(int id) async {
    final response = await _apiClient.delete('/api/appointments/$id');
    if (response.statusCode != 204) {
      throw Exception(
        'Failed to delete appointment (status: ${response.statusCode})',
      );
    }
  }
}
