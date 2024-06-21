import 'package:bloc/bloc.dart';
import 'package:flutter_dio_sample/features/authentication/services/api_service.dart';
import 'package:flutter_dio_sample/features/model/user.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUpButtonPressed>(_onSignupPressed);
    on<AuthSignInButtonPressed>(_onSignInPressed);
  }

  void _onSignupPressed(
      AuthSignUpButtonPressed event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    try {
      ApiService().register(User(
          userName: event.userName,
          email: event.email,
          password: event.password));
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(errorMsg: e.toString()));
    }
  }

  void _onSignInPressed(
      AuthSignInButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await ApiService()
          .login(User(email: event.email, password: event.password));
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(errorMsg: e.toString()));
    }
  }
}
