part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class Empty extends AuthState {}

class Success extends AuthState {}

class Error extends AuthState {
  late final String message;
}