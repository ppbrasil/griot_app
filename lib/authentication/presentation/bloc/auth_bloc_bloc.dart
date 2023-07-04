import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String AUTHENTICATION_FAILED = 'Authentication Failed';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final PerformLogin performLogin;

  AuthBlocBloc({required this.performLogin}) : super(AuthBlocInitialState()) {
    on<SignInWithCredentialsEvent>((event, emit) async {
      final result = await performLogin.call(Params(
        username: event.username,
        password: event.password,
      ));

      result.fold(
        (failure) => emit(AuthBlocLoginFailedState()),
        (token) => emit(AuthBlocAuthorizedState(token: token)),
      );
    });
    on<TokenFailedEvent>((event, emit) {
      emit(AuthBlocUnauthorizedState());
    });
  }
}
