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
