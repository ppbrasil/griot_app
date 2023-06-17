import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemoryUseCase;
import 'package:griot_app/memories/domain/usecases/get_memories_list.dart'
    as getMemoriesUseCase;
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart'
    as getMemoryUseCase;

part 'memories_bloc_event.dart';
part 'memories_bloc_state.dart';

class MemoriesBlocBloc extends Bloc<MemoriesBlocEvent, MemoriesBlocState> {
  final getMemoryUseCase.GetMemoriesUseCase getMemory;
  final getMemoriesUseCase.GetMemoriesList getMemories;
  final createMemoryUseCase.CreateMemoriesUseCase createMemory;

  MemoriesBlocBloc(
      {required this.getMemory,
      required this.getMemories,
      required this.createMemory})
      : super(MemoriesInitial()) {
    on<GetMemoryDetailsEvent>((event, emit) async {
      emit(MemoryGetDetailsLoading());
      final memoryEither =
          await getMemory(getMemoryUseCase.Params(memoryId: event.memoryId));
      memoryEither.fold(
        (failure) => emit(
            MemoryGetDetailsFailure(message: 'Failed to fetch memory details')),
        (memory) => emit(MemoryGetDetailsSuccess(memory: memory)),
      );
    });

    on<CreateMemoryEvent>((event, emit) async {
      emit(MemoryCreationLoading());
      final memoryEither =
          await createMemory(createMemoryUseCase.Params(title: event.title));
      memoryEither.fold(
        (failure) =>
            emit(MemoryCreationFailure(message: 'Failed to create memory')),
        (memory) => emit(MemoryCreationSuccess(memory: memory)),
      );
    });

    on<GetMemoriesListEvent>((event, emit) async {
      emit(MemoriesGetListLoading());
      final memoriesEither = await getMemories(getMemoriesUseCase.NoParams());
      memoriesEither.fold(
        (failure) => emit(const MemoriesGetListFailure(
            message: 'Failed to fetch memory list')),
        (memories) => emit(MemoriesGetListSuccess(memories: memories)),
      );
    });
  }
}
