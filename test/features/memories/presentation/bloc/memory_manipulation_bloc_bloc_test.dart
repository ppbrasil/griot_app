import 'package:dartz/dartz.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/services/field_validation.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemory;
import 'package:griot_app/memories/domain/usecases/add_video_from_library_to_memory_usecase.dart'
    as addVideosToMemory;
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart'
    as getMemoryDetails;
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';

import 'memory_manipulation_bloc_bloc_test.mocks.dart';

@GenerateMocks([
  createMemory.CreateMemoriesUseCase,
  addVideosToMemory.AddVideoFromLibraryToMemoryUseCase,
  getMemoryDetails.GetMemoriesUseCase,
  MainAccountIdProvider,
])
void main() {
  late ValidationService validator;
  late MemoryManipulationBlocBloc bloc;
  late MockCreateMemoriesUseCase mockCreateMemoriesUseCase;
  late MockAddVideoFromLibraryToMemoryUseCase
      mockAddVideoFromLibraryToMemoryUseCase;
  late MockGetMemoriesUseCase mockGetMemoriesUseCase;
  late MockMainAccountIdProvider mockMainAccountIdProvider;

  setUp(() {
    validator = ValidationService();
    mockCreateMemoriesUseCase = MockCreateMemoriesUseCase();
    mockAddVideoFromLibraryToMemoryUseCase =
        MockAddVideoFromLibraryToMemoryUseCase();
    mockMainAccountIdProvider = MockMainAccountIdProvider();
    mockGetMemoriesUseCase = MockGetMemoriesUseCase();

    bloc = MemoryManipulationBlocBloc(
      createMemory: mockCreateMemoriesUseCase,
      addVideos: mockAddVideoFromLibraryToMemoryUseCase,
      accountIdProvider: mockMainAccountIdProvider,
      getMemoryDetails: mockGetMemoriesUseCase,
      validator: validator,
    );
  });

  group('CreateNewMemoryClickedEvent', () {
    const tTitle = '';
    const tAccountId = 1;
    Memory tMemory = Memory(
      title: tTitle,
      videos: const [],
      accountId: tAccountId,
      id: null,
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryCreationSuccess state when memory creation is successful',
      build: () {
        when(mockMainAccountIdProvider.getMainAccountId())
            .thenAnswer((_) async => tAccountId);
        when(mockCreateMemoriesUseCase.call(const createMemory.Params(
            title: tTitle,
            id: null,
            accountId: tAccountId,
            videos: []))).thenAnswer((_) async => Right(tMemory));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateNewMemoryClickedEvent()),
      expect: () => [
        MemoryLoading(),
        MemoryManipulationSuccessState(memory: tMemory),
      ],
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryCreationFailure state when memory creation fails',
      build: () {
        when(mockMainAccountIdProvider.getMainAccountId())
            .thenAnswer((_) async => tAccountId);
        when(mockCreateMemoriesUseCase.call(const createMemory.Params(
                title: tTitle, id: null, accountId: tAccountId, videos: [])))
            .thenAnswer((_) async =>
                const Left(ServerFailure(message: 'Failed to create memory')));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateNewMemoryClickedEvent()),
      expect: () => [
        MemoryLoading(),
        MemoryCreationBlocFailure(),
      ],
    );
  });

  group('MemoryTitleChangedEvent', () {
    const tPreviousTitle = null;
    const tValidTitle = 'This is a valid title';
    const tShortTitle = '1234567';
    const tLogTitle =
        'This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. ';

    const tSavingErrorMessage = null;
    const tvideoAddingErrorMesssage = null;

    Memory tOriginalMemory = Memory(
      id: null,
      title: tPreviousTitle,
      accountId: 1,
      videos: null,
    );

    Memory tUpdatedValidMemory = Memory(
      id: null,
      title: tValidTitle,
      accountId: 1,
      videos: null,
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationSuccessState state when title is successfully updated in a previously succesful memory',
      // arrange
      build: () => bloc,
      //act
      act: (bloc) => bloc.add(MemoryTitleChangedEvent(
        title: tValidTitle,
        memory: tOriginalMemory,
        savingErrorMesssage: tSavingErrorMessage,
        videoAddingErrorMesssage: tvideoAddingErrorMesssage,
      )),
      //assert
      expect: () => [
        MemoryManipulationSuccessState(memory: tUpdatedValidMemory),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState state when title is empty',
      // arrange
      build: () => bloc,
      //act
      act: (bloc) => bloc.add(MemoryTitleChangedEvent(
        title: '',
        memory: tOriginalMemory,
        savingErrorMesssage: tSavingErrorMessage,
        videoAddingErrorMesssage: tvideoAddingErrorMesssage,
      )),
      //assert
      expect: () => [
        const MemoryManipulationFailureState(
          titleErrorMesssage: 'Please enter a title for your memory',
          videoAddingErrorMesssage: null,
          savingErrorMesssage: null,
        ),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState state when title is toos short',
      // arrange
      build: () => bloc,
      //act
      act: (bloc) => bloc.add(MemoryTitleChangedEvent(
        title: tShortTitle,
        memory: tOriginalMemory,
        savingErrorMesssage: tSavingErrorMessage,
        videoAddingErrorMesssage: tvideoAddingErrorMesssage,
      )),
      //assert
      expect: () => [
        const MemoryManipulationFailureState(
          titleErrorMesssage: 'Titles must have at least 8 characters',
          videoAddingErrorMesssage: null,
          savingErrorMesssage: null,
        ),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState state when title is toos long',
      // arrange
      build: () => bloc,
      //act
      act: (bloc) => bloc.add(MemoryTitleChangedEvent(
        title: tLogTitle,
        memory: tOriginalMemory,
        savingErrorMesssage: tSavingErrorMessage,
        videoAddingErrorMesssage: tvideoAddingErrorMesssage,
      )),
      //assert
      expect: () => [
        const MemoryManipulationFailureState(
          titleErrorMesssage: 'Titles can\'t have more then 255 characters',
          videoAddingErrorMesssage: null,
          savingErrorMesssage: null,
        ),
      ],
    );
  });
}
