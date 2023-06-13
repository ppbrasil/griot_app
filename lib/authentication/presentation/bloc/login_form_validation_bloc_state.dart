part of 'login_form_validation_bloc_bloc.dart';

abstract class LoginFormValidationBlocState extends Equatable {
  final String? usernameErrorMessage;
  final String? passwordErrorMessage;

  const LoginFormValidationBlocState(
      {this.usernameErrorMessage, this.passwordErrorMessage});

  @override
  List<Object?> get props => [usernameErrorMessage, passwordErrorMessage];
}

class LoginFormValidationBlocInitial extends LoginFormValidationBlocState {
  const LoginFormValidationBlocInitial()
      : super(usernameErrorMessage: null, passwordErrorMessage: null);
}

class LoginFormValidationFailedState extends LoginFormValidationBlocState {
  const LoginFormValidationFailedState({
    String? usernameErrorMessage,
    String? passwordErrorMessage,
  }) : super(
            usernameErrorMessage: usernameErrorMessage,
            passwordErrorMessage: passwordErrorMessage);
}

class LoginFormValidationSuccessdState extends LoginFormValidationBlocState {
  const LoginFormValidationSuccessdState()
      : super(usernameErrorMessage: null, passwordErrorMessage: null);
}
