import 'dart:convert';

import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_session_model.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );

    return _decodeSessionResponse(response.statusCode, response.body);
  }

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/login',
      body: {'email': email, 'password': password},
    );

    return _decodeSessionResponse(response.statusCode, response.body);
  }

  Future<AuthUserModel> fetchCurrentUser() async {
    final response = await _apiClient.get('/api/auth/me');

    if (response.statusCode != 200) {
      throw AuthException(_readMessage(response.body) ?? 'Session expired');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected current user response format');
    }

    return AuthUserModel.fromJson(decoded['user'] as Map<String, dynamic>);
  }

  Future<void> deleteAccount() async {
    final response = await _apiClient.delete('/api/auth/me');

    if (response.statusCode != 204) {
      throw AuthException(_readMessage(response.body) ?? 'Delete failed');
    }
  }

  AuthSessionModel _decodeSessionResponse(int statusCode, String body) {
    if (statusCode != 200 && statusCode != 201) {
      throw AuthException(_readMessage(body) ?? 'Authentication failed');
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected auth response format');
    }

    return AuthSessionModel.fromJson(decoded);
  }

  String? _readMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] as String?;
      }
    } on FormatException {
      return null;
    }

    return null;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
