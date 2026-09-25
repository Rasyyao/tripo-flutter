import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripo/repositories/auth_repository.dart';

// ---- Events ----
sealed class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  LoginSubmitted({required this.email, required this.password});
  final String email;
  final String password;
}

class SignUpSubmitted extends AuthEvent {
  SignUpSubmitted({required this.email, required this.password});
  final String email;
  final String password;
}

/// Clears server errors when the user starts editing again.
class AuthErrorsCleared extends AuthEvent {}

// ---- State ----
enum AuthStatus { initial, loading, success, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.emailError,
    this.passwordError,
    this.message,
  });

  final AuthStatus status;
  final String? emailError;
  final String? passwordError;
  final String? message;

  bool get isLoading => status == AuthStatus.loading;
}

// ---- Bloc ----
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState()) {
    on<LoginSubmitted>(_onLogin);
    on<SignUpSubmitted>(_onSignUp);
    on<AuthErrorsCleared>((_, emit) => emit(const AuthState()));
  }

  final AuthRepository _repo;

  Future<void> _onLogin(LoginSubmitted e, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _repo.login(e.email, e.password);
      emit(const AuthState(status: AuthStatus.success));
    } on InvalidCredentialsException {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          passwordError: 'Incorrect email or password',
        ),
      );
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _onSignUp(SignUpSubmitted e, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _repo.signUp(e.email, e.password);
      emit(const AuthState(status: AuthStatus.success));
    } on EmailTakenException {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          emailError: 'This email is already registered',
        ),
      );
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
