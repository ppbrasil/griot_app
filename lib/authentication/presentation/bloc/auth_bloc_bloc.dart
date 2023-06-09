import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/usecases/perform_check_logged_in_usecase.dart'
    as checkLoggedInUseCase;
import 'package:griot_app/authentication/domain/usecases/perform_login.dart'
    as LoginUseCase;
import 'package:griot_app/authentication/domain/usecases/perform_logout.dart'
    as LogoutUseCase;

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String AUTHENTICATION_FAILED = 'Authentication Failed';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final LoginUseCase.PerformLogin performLogin;
  final LogoutUseCase.PerformLogout performLogout;
  final checkLoggedInUseCase.CheckLoggedInUseCase checkLoggedIn;

  AuthBlocBloc({
    required this.performLogin,
    required this.performLogout,
    required this.checkLoggedIn,
  }) : super(AuthBlocInitialState()) {
    on<AuthBlocLoadingApplicationEvent>((event, emit) async {
      final result =
          await checkLoggedIn.call(const checkLoggedInUseCase.NoParams());
      result.fold(
        (failure) => emit(AuthBlocUnauthorizedState()),
        (token) => emit(AuthBlocAuthorizedState(token: token)),
      );
    });

    on<SignInWithCredentialsEvent>((event, emit) async {
      final result = await performLogin.call(LoginUseCase.Params(
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
    on<LogoutEvent>((event, emit) async {
      final result = await performLogout.call(const LogoutUseCase.NoParams());
      result.fold(
        (failuer) => emit(AuthBlocLogoutFailedState()),
        (success) => emit(AuhtBlocLoggedOutState()),
      );
    });
  }
}
