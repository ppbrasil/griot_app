import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/services/field_validation.dart';

part 'login_form_validation_bloc_event.dart';
part 'login_form_validation_bloc_state.dart';

class LoginFormValidationBloc
    extends Bloc<LoginFormValidationBlocEvent, LoginFormValidationBlocState> {
  final ValidationService validationService;

  LoginFormValidationBlocState currentState =
      const LoginFormValidationBlocInitial();

  LoginFormValidationBloc({required this.validationService})
      : super(const LoginFormValidationBlocInitial()) {
    on<EmailChanged>((event, emit) {
      final validationMessage =
          validationService.validateUsername(event.username);
      if (validationMessage != null || state.passwordErrorMessage != null) {
        emit(LoginFormValidationFailedState(
            usernameErrorMessage: validationMessage,
            passwordErrorMessage: state.passwordErrorMessage));
      } else {
        emit(const LoginFormValidationSuccessdState());
      }
    });

    on<PasswordChanged>((event, emit) {
      final validationMessage =
          validationService.validatePassword(event.password);
      if (validationMessage != null || state.usernameErrorMessage != null) {
        emit(LoginFormValidationFailedState(
            usernameErrorMessage: state.usernameErrorMessage,
            passwordErrorMessage: validationMessage));
      } else {
        emit(const LoginFormValidationSuccessdState());
      }
    });
  }
}
