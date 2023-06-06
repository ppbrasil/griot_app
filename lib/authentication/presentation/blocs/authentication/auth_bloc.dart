/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/presentation/blocs/authentication/auth_event.dart';
import 'package:griot_app/authentication/blocs/authentication/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(InitialState());

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginAttemptEvent) {
      yield* _mapLoginAttemptToState(event);
    }
  }

  Stream<AuthState> _mapLoginAttemptToState(LoginAttemptEvent event) async* {
    try {
      final token = await authRepository.login(event.email, event.password);
      yield token.fold(
        (failure) => LoginFailedState(error: failure.toString()),
        (token) => UserLoggedInState(),
      );
    } catch (_) {
      yield const LoginFailedState(error: 'Unknown error');
    }
  }
}
*/
