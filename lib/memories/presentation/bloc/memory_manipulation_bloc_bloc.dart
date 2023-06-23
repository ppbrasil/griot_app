import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemoryUseCase;
import 'package:griot_app/memories/domain/usecases/get_video_from_library_usecase.dart'
    as getLibraryVideosUseCase;

part 'memory_manipulation_bloc_event.dart';
part 'memory_manipulation_bloc_state.dart';

class MemoryManipulationBlocBloc
    extends Bloc<MemoryManipulationBlocEvent, MemoryManipulationBlocState> {
  final createMemoryUseCase.CreateMemoriesUseCase createMemory;
  final getLibraryVideosUseCase.GetVideoFromLibraryUseCase getLibraryVideos;

  MemoryManipulationBlocBloc(
      {required this.createMemory, required this.getLibraryVideos})
      : super(MemoryCreationBlocInitial()) {
    on<CreateMemoryEvent>((event, emit) async {
      emit(MemoryCreationBlocLoading());
      final memoryEither =
          await createMemory(createMemoryUseCase.Params(title: event.title));
      memoryEither.fold(
        (failure) => emit(MemoryCreationBlocFailure()),
        (memory) => emit(MemoryUpdateSuccessState(memory: memory)),
      );
    });
  }
}
