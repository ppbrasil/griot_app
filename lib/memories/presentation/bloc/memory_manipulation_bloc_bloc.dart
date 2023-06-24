import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';

import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemoryUseCase;
import 'package:griot_app/memories/domain/usecases/add_video_from_library_to_memory_usecase.dart'
    as addLibraryVideosUseCase;
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart'
    as getMemoryUseCase;

part 'memory_manipulation_bloc_event.dart';
part 'memory_manipulation_bloc_state.dart';

class MemoryManipulationBlocBloc
    extends Bloc<MemoryManipulationBlocEvent, MemoryManipulationBlocState> {
  final createMemoryUseCase.CreateMemoriesUseCase createMemory;
  final addLibraryVideosUseCase.AddVideoFromLibraryToMemoryUseCase addVideos;
  final getMemoryUseCase.GetMemoriesUseCase getMemoryDetails;
  final MainAccountIdProvider accountIdProvider;

  MemoryManipulationBlocBloc({
    required this.createMemory,
    required this.addVideos,
    required this.accountIdProvider,
    required this.getMemoryDetails,
  }) : super(MemoryCreationBlocInitial()) {
    on<CreateMemoryEvent>((event, emit) async {
      emit(MemoryLoading());
      ;
      final memoryEither = await createMemory(createMemoryUseCase.Params(
        id: null,
        accountId: await accountIdProvider.getMainAccountId(),
        title: event.title,
        videos: event.videos,
      ));
      memoryEither.fold(
        (failure) => emit(MemoryCreationBlocFailure()),
        (memory) => emit(MemorySuccessState(memory: memory)),
      );
    });
    on<AddVideoClickedEvent>((event, emit) async {
      final updatedMemory = await addVideos(addLibraryVideosUseCase.Params(
        memory: event.memory,
      ));
      updatedMemory.fold(
        (failure) => emit(MemoryCreationBlocFailure()),
        (memory) => emit(MemorySuccessState(memory: memory)),
      );
    });
    on<GetMemoryDetailsEvent>((event, emit) async {
      emit(MemoryLoading());
      final memoryEither = await getMemoryDetails(
          getMemoryUseCase.Params(memoryId: event.memoryId));
      memoryEither.fold(
        (failure) => emit(MemoryFailureState()),
        (memory) => emit(MemorySuccessState(memory: memory)),
      );
    });
  }
}
