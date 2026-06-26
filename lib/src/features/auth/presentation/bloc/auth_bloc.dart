import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final UserModel user;
  const LoginSuccess(this.user);
}

class RegisterSuccess extends AuthState {
  final UserModel user;
  const RegisterSuccess(this.user);
}

class LogoutSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  UserModel? get currentUser {
    final s = state;
    if (s is LoginSuccess) return s.user;
    if (s is RegisterSuccess) return s.user;
    return null;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    final ok = await AuthService.login(username: username, password: password);
    if (ok) {
      final user = await AuthService.getCurrentUser();
      emit(LoginSuccess(user!));
    } else {
      emit(const AuthError('Invalid username or password.'));
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String avatarIcon,
  }) async {
    emit(AuthLoading());
    final ok = await AuthService.register(
      username: username,
      password: password,
      avatarIcon: avatarIcon,
    );
    if (ok) {
      final user = await AuthService.getCurrentUser();
      emit(RegisterSuccess(user!));
    } else {
      emit(const AuthError('Username already exists.'));
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    emit(LogoutSuccess());
  }
}
