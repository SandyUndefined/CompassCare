import 'package:compasscare_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:compasscare_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_session_model.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';
import 'package:compasscare_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource {
    _session = _localDataSource.readSession();
  }

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthSessionModel? _session;

  @override
  String? get currentToken => _session?.token;

  @override
  AuthUserModel? restoreUser() {
    _session ??= _localDataSource.readSession();
    return _session?.user;
  }

  @override
  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    await _saveSession(session);
    return session.user;
  }

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _saveSession(session);
    return session.user;
  }

  @override
  Future<void> logout() async {
    _session = null;
    await _localDataSource.clearSession();
  }

  @override
  Future<void> deleteAccount() async {
    await _remoteDataSource.deleteAccount();
    _session = null;
    await _localDataSource.clearSession();
  }

  Future<void> _saveSession(AuthSessionModel session) async {
    _session = session;
    await _localDataSource.saveSession(session);
  }
}
