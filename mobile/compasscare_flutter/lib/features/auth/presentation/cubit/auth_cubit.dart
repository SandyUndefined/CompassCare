import 'package:compasscare_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:compasscare_flutter/features/auth/data/models/auth_user_model.dart';
import 'package:compasscare_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, submitting }

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.errorMessage});

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  final AuthStatus status;
  final AuthUserModel? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, user, errorMessage];

  AuthState copyWith({
    AuthStatus? status,
    AuthUserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthState.unknown());

  final AuthRepository _repository;

  void restoreSession() {
    final user = _repository.restoreUser();
    emit(
      user == null
          ? const AuthState(status: AuthStatus.unauthenticated)
          : AuthState(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: _messageFor(error),
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));
    try {
      final user = await _repository.login(email: email, password: password);
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          errorMessage: _messageFor(error),
        ),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> deleteAccount() async {
    final currentUser = state.user;
    try {
      await _repository.deleteAccount();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (error) {
      emit(
        AuthState(
          status: currentUser == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          user: currentUser,
          errorMessage: _messageFor(error),
        ),
      );
      rethrow;
    }
  }

  String _messageFor(Object error) {
    if (error is AuthException) {
      return error.message;
    }

    return 'Unable to authenticate right now. Please try again.';
  }
}
