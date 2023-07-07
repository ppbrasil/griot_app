part of 'auth_bloc_bloc.dart';

abstract class AuthBlocEvent extends Equatable {
  const AuthBlocEvent();

  @override
  List<Object> get props => [];
}

class AuthBlocLoadingApplicationEvent extends AuthBlocEvent {}

class SignInWithCredentialsEvent extends AuthBlocEvent {
  final String username;
  final String password;

  const SignInWithCredentialsEvent(
      {required this.username, required this.password});
}

class TokenFailedEvent extends AuthBlocEvent {}

class LogoutEvent extends AuthBlocEvent {}
