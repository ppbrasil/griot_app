import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/services/field_validation.dart';

import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/usecases/add_video_list_from_library_to_draft_memory_usecase.dart'
    as addLibraryVideosToDraftUseCase;
import 'package:griot_app/memories/domain/usecases/commit_changes_to_memory_usecase.dart'
    as CommitMemoryUseCase;
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
  final addLibraryVideosToDraftUseCase
      .AddVideoListFromLibraryToDraftMemoryUseCase addVideosToDraft;
  final getMemoryUseCase.GetMemoriesUseCase getMemoryDetails;
  final CommitMemoryUseCase.CommitChangesToMemoryUseCase commitMemory;
  final MainAccountIdProvider accountIdProvider;
  final ValidationService validationService;

  MemoryManipulationBlocBloc({
    required this.createMemory,
    required this.addVideos,
    required this.accountIdProvider,
    required this.getMemoryDetails,
    required this.validationService,
    required this.addVideosToDraft,
    required this.commitMemory,
  }) : super(const MemoryCreationBlocInitial(memory: null)) {
    // Evaluate a Create new draft memory trial
    on<CreateNewMemoryClickedEvent>((event, emit) async {
      emit(const MemoryLoading(memory: null));
      final memoryEither = await createMemory(createMemoryUseCase.Params(
        id: null,
        accountId: await accountIdProvider.getMainAccountId(),
        title: '',
        videos: const [],
      ));
      memoryEither.fold(
        (failure) => emit(const MemoryCreationBlocFailure(memory: null)),
        (memory) => emit(MemoryManipulationSuccessState(memory: memory)),
      );
    });

    //Evaluate a Retrieve memory details trial
    on<GetMemoryDetailsEvent>((event, emit) async {
      emit(const MemoryLoading(memory: null));
      final memoryEither = await getMemoryDetails(
          getMemoryUseCase.Params(memoryId: event.memoryId));
      memoryEither.fold(
        (failure) => emit(const MemoryRetrievalFailureState(memory: null)),
        (memory) => emit(MemoryManipulationSuccessState(memory: memory)),
      );
    });

    //Evaluate a title update trial
    on<MemoryTitleChangedEvent>((event, emit) async {
      final validationMessage =
          validationService.validateMemoryTitle(event.title);
      final previousState = state;

      if (validationMessage != null) {
        if (previousState is MemoryManipulationFailureState) {
          emit(MemoryManipulationFailureState(
              titleErrorMesssage: validationMessage,
              videoAddingErrorMesssage: previousState.videoAddingErrorMesssage,
              savingErrorMesssage: previousState.savingErrorMesssage,
              memory: previousState.memory));
        } else {
          emit(MemoryManipulationFailureState(
              titleErrorMesssage: validationMessage,
              videoAddingErrorMesssage: '',
              savingErrorMesssage: '',
              memory: previousState.memory));
        }
      } else {
        Memory updateMemory = state.memory!.copyWith(title: event.title);
        emit(MemoryManipulationSuccessState(
          memory: updateMemory,
        ));
      }
    });

    // Evaluate an Add Videos to Draft trial
    on<AddVideoClickedEvent>((event, emit) async {
      final updatedMemory = await addVideosToDraft(
          addLibraryVideosToDraftUseCase.Params(memory: event.memory));
      final previousState = state;
      updatedMemory.fold(
        (failure) {
          // Check if previous state was a MemoryManipulationFailureState
          if (previousState is MemoryManipulationFailureState) {
            emit(MemoryManipulationFailureState(
              memory: previousState.memory,
              titleErrorMesssage: previousState.titleErrorMesssage,
              videoAddingErrorMesssage: 'Unable to retrieve media from library',
              savingErrorMesssage: '',
            ));
          } else {
            emit(MemoryManipulationFailureState(
              memory: previousState.memory,
              titleErrorMesssage: '',
              videoAddingErrorMesssage: 'Unable to retrieve media from library',
              savingErrorMesssage: '',
            ));
          }
        },
        (memory) => emit(MemoryManipulationSuccessState(memory: memory)),
      );
    });

    // Evaluate a trial to Commmit changes
    on<CommitMemoryEvent>((event, emit) async {
      final previousState = state;
      final updatedMemory =
          await commitMemory(CommitMemoryUseCase.Params(memory: event.memory));

      updatedMemory.fold(
        (failure) {
          // Check if previous state was a MemoryManipulationFailureState
          if (previousState is MemoryManipulationFailureState) {
            emit(MemoryManipulationFailureState(
              memory: previousState.memory,
              titleErrorMesssage: previousState.titleErrorMesssage,
              videoAddingErrorMesssage: previousState.videoAddingErrorMesssage,
              savingErrorMesssage: 'Unable to save changes',
            ));
          } else {
            emit(MemoryManipulationFailureState(
              memory: previousState.memory,
              titleErrorMesssage: '',
              videoAddingErrorMesssage: '',
              savingErrorMesssage: 'Unable to save changes',
            ));
          }
        },
        (memory) => emit(MemoryManipulationSuccessState(memory: memory)),
      );
    });
  }
}
