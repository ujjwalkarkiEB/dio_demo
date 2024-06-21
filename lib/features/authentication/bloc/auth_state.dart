part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String errorMsg;

  AuthError({required this.errorMsg});
}

final class AuthSuccess extends AuthState {}
