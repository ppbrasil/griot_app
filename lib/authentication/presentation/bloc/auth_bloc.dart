import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String AUTHENTICATION_FAILED = 'Authentication Failed';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PerformLogin performLogin;

  AuthBloc({required this.performLogin}) : super(Empty()) {
    on<SignInWithCredentials>(
      (event, emit) async {
        final result = await performLogin.call(Params(
          username: event.username,
          password: event.password,
        ));

        result.fold(
          (failure) => emit(Error()),
          (token) => emit(Success()),
        );
      },
    );
  }
}
