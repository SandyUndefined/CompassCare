import 'dart:convert';

import 'package:compasscare_flutter/features/auth/data/models/auth_session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource({required SharedPreferences preferences})
    : _preferences = preferences;

  static const _sessionPreferenceKey = 'auth_session';

  final SharedPreferences _preferences;

  AuthSessionModel? readSession() {
    final encodedSession = _preferences.getString(_sessionPreferenceKey);
    if (encodedSession == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(encodedSession);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return AuthSessionModel.fromJson(decoded);
    } on Object {
      return null;
    }
  }

  Future<void> saveSession(AuthSessionModel session) {
    return _preferences.setString(
      _sessionPreferenceKey,
      jsonEncode(session.toJson()),
    );
  }

  Future<void> clearSession() {
    return _preferences.remove(_sessionPreferenceKey);
  }
}
