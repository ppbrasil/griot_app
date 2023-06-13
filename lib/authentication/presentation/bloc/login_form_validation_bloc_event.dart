part of 'login_form_validation_bloc_bloc.dart';

abstract class LoginFormValidationBlocEvent extends Equatable {
  const LoginFormValidationBlocEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginFormValidationBlocEvent {
  final String username;

  const EmailChanged({required this.username});
}

class PasswordChanged extends LoginFormValidationBlocEvent {
  final String password;

  const PasswordChanged({required this.password});
}

class LoginFormSubmitted extends LoginFormValidationBlocEvent {}
