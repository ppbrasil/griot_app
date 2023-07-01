import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_session_bloc_event.dart';
part 'user_session_bloc_state.dart';

class UserSessionBlocBloc
    extends Bloc<UserSessionBlocEvent, UserSessionBlocState> {
  UserSessionBlocBloc() : super(UserSessionBlocInitial()) {
    on<TokenFailedBlocEvent>((event, emit) {
      emit(UserLostSessionState());
    });
  }
}
