import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({required this.token, required this.user});

  final String token;
  final AuthUserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token'] as String,
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}
