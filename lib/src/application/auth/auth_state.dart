part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isAuthenticated = false,
  });
  final bool isAuthenticated;

  @override
  List<Object> get props => [
    isAuthenticated,
  ];
  AuthState copyWith({
    bool? isAuthenticated,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
