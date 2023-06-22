import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'memory_creation_bloc_event.dart';
part 'memory_creation_bloc_state.dart';

class MemoryCreationBlocBloc extends Bloc<MemoryCreationBlocEvent, MemoryCreationBlocState> {
  MemoryCreationBlocBloc() : super(MemoryCreationBlocInitial()) {
    on<MemoryCreationBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
