part of 'auth_bloc_bloc.dart';

abstract class AuthBlocState extends Equatable {
  const AuthBlocState();

  @override
  List<Object> get props => [];
}

class AuthBlocInitialState extends AuthBlocState {}

class AuthBlocAuthorizedState extends AuthBlocState {
  final Token token;
  const AuthBlocAuthorizedState({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthBlocUnauthorizedState extends AuthBlocState {}

class AuthBlocLoginFailedState extends AuthBlocState {
  late final String message;
}

class AuhtBlocLoggedOutState extends AuthBlocState {
  late final String message;
}

class AuthBlocLogoutFailedState extends AuthBlocState {
  late final String message;
}
