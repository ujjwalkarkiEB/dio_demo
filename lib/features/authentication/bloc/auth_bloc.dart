import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dio_sample/features/authentication/services/api_service.dart';
import 'package:flutter_dio_sample/features/authentication/model/user.dart';
import 'package:flutter_dio_sample/utils/network/helper/token_manager.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSignUpButtonPressed>(_onSignupPressed);
    on<AuthSignInButtonPressed>(_onSignInPressed);
    on<AuthLogoutRequested>(_logoutEventOcurred);
  }

  void _logoutEventOcurred(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await TokenManager().clearTokens();
    emit(AuthLogout());
  }

  void _onSignupPressed(
      AuthSignUpButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await ApiService().register(User(
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
