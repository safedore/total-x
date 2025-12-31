part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SetAuthenticated extends AuthEvent {
  const SetAuthenticated({required this.isAuthenticated});
  final bool isAuthenticated;
}
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ResetAuthEvent extends AuthEvent {}
