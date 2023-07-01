import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_bloc_event.dart';
part 'connectivity_bloc_state.dart';

class ConnectivityBlocBloc
    extends Bloc<ConnectivityBlocEvent, ConnectivityBlocState> {
  ConnectivityBlocBloc() : super(ConnectivityBlocInitial()) {
    on<ConnectivityBlocEvent>((event, emit) {
      emit(ConnectivityBlocDisconnected());
    });
  }
}
