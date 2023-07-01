part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInWithCredentials extends AuthEvent {
  final String username;
  final String password;

  const SignInWithCredentials({required this.username, required this.password});
}

class InvalidTokenEvent extends AuthEvent {}
