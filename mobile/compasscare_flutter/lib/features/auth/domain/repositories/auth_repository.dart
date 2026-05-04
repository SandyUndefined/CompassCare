import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';

abstract class AuthRepository {
  String? get currentToken;

  AuthUserModel? restoreUser();

  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteAccount();
}
