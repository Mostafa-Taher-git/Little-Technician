import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  LoginEvent({required this.username, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String avatarIcon;
  RegisterEvent({required this.username, required this.password, required this.avatarIcon});
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class RegisterSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final ok = await AuthService.login(username: event.username, password: event.password);
    if (ok) {
      emit(LoginSuccess());
    } else {
      emit(const AuthError('Invalid username or password.'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final ok = await AuthService.register(
      username: event.username,
      password: event.password,
      avatarIcon: event.avatarIcon,
    );
    if (ok) {
      emit(RegisterSuccess());
    } else {
      emit(const AuthError('Username already exists.'));
    }
  }
}
