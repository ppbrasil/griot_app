import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialState extends AuthState {}

class UserLoggedInState extends AuthState {}

class LoginFailedState extends AuthState {
  final String error;

  const LoginFailedState({required this.error});

  @override
  List<Object> get props => [error];
}
