part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthSignUpButtonPressed extends AuthEvent {
  final String userName;
  final String email;
  final String password;

  AuthSignUpButtonPressed({
    required this.userName,
    required this.email,
    required this.password,
  });
}

final class AuthSignInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  AuthSignInButtonPressed({required this.email, required this.password});
}
