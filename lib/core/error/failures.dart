import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List<Object>? properties]) : super();

  @override
  List<Object> get props => [];
}

class AuthenticationFailure extends Failure {
  final String message;
  const AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class InvalidTokenFailure extends Failure {
  final String message;

  const InvalidTokenFailure({this.message = "Invalid token"}) : super();

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure({required this.message});

  @override
  List<Object> get props => [message];
}
