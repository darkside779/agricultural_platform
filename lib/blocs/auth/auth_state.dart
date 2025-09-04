part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  error,
  passwordResetSent,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final app_user.User? user;
  final String? error;

  const AuthState._({
    required this.status,
    this.user,
    this.error,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(app_user.User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.error(String message)
      : this._(status: AuthStatus.error, error: message);

  const AuthState.passwordResetSent()
      : this._(status: AuthStatus.passwordResetSent);

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get isError => status == AuthStatus.error;
  bool get isPasswordResetSent => status == AuthStatus.passwordResetSent;

  @override
  List<Object?> get props => [status, user, error];
}
