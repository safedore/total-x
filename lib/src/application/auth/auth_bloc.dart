import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:totalx/src/domain/core/pref_key/preference_key.dart';
import 'package:totalx/src/infrastructure/core/preference_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<SetAuthenticated>(_setAuthentication);
    on<LogoutEvent>(_logout);
    on<ResetAuthEvent>(_resetAuth);
  }

  FutureOr<void> _setAuthentication(
    SetAuthenticated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState(isAuthenticated: event.isAuthenticated));
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    PreferenceHelper().remove(key: AppPrefKeys.token);
    emit(AuthState(isAuthenticated: false));
  }

  FutureOr<void> _resetAuth(
    ResetAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState());
  }
}
