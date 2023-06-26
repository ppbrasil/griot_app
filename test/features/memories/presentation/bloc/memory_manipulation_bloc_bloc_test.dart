import 'package:dartz/dartz.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/services/field_validation.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/usecases/add_video_list_from_library_to_draft_memory_usecase.dart'
    as addVideosToDraft;
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
  MainAccountIdProvider,
  createMemory.CreateMemoriesUseCase,
  addVideosToMemory.AddVideoFromLibraryToMemoryUseCase,
  getMemoryDetails.GetMemoriesUseCase,
  addVideosToDraft.AddVideoListFromLibraryToDraftMemoryUseCase,
])
void main() {
  late ValidationService validator;
  late MemoryManipulationBlocBloc bloc;
  late MockCreateMemoriesUseCase mockCreateMemoriesUseCase;
  late MockAddVideoFromLibraryToMemoryUseCase
      mockAddVideoFromLibraryToMemoryUseCase;
  late MockGetMemoriesUseCase mockGetMemoriesUseCase;
  late MockMainAccountIdProvider mockMainAccountIdProvider;
  late MockAddVideoListFromLibraryToDraftMemoryUseCase mockAddVideosToDraft;

  setUp(() {
    mockMainAccountIdProvider = MockMainAccountIdProvider();
    validator = ValidationService();
    mockCreateMemoriesUseCase = MockCreateMemoriesUseCase();
    mockAddVideoFromLibraryToMemoryUseCase =
        MockAddVideoFromLibraryToMemoryUseCase();
    mockGetMemoriesUseCase = MockGetMemoriesUseCase();
    mockAddVideosToDraft = MockAddVideoListFromLibraryToDraftMemoryUseCase();

    bloc = MemoryManipulationBlocBloc(
      createMemory: mockCreateMemoriesUseCase,
      addVideos: mockAddVideoFromLibraryToMemoryUseCase,
      accountIdProvider: mockMainAccountIdProvider,
      getMemoryDetails: mockGetMemoriesUseCase,
      validationService: validator,
      addVideosToDraft: mockAddVideosToDraft,
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

  group('AddVideoClickedEvent', () {
    // Define needed variables
    int tId = 1;
    String tTitle = 'Title';
    int tAccountId = 1;
    List<Video> tOriginalVideosList = [];

    Memory tMemory = Memory(
      id: tId,
      title: tTitle,
      accountId: tAccountId,
      videos: tOriginalVideosList,
    );

    Video tVideo1 = const Video(
      id: 1,
      file: 'myUrl',
      thumbnail: 'myThumb',
      name: null,
      memoryId: null,
    );
    List<Video> tFinalVideoList = [tVideo1];

    Memory tUpdatedMemory = Memory(
      id: tId,
      title: tTitle,
      accountId: tAccountId,
      videos: tFinalVideoList,
    );

    // Implement bloctest scenarios
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationSuccessState when succefully retrieving videos from library',
      // arrange
      build: () {
        when(mockAddVideosToDraft
                .call(addVideosToDraft.Params(memory: tMemory)))
            .thenAnswer((_) async => Right(tUpdatedMemory));
        return bloc;
      },
      //act
      act: (bloc) => bloc.add(AddVideoClickedEvent(memory: tMemory)),
      //assert
      expect: () => [
        MemoryManipulationSuccessState(memory: tUpdatedMemory),
      ],
    );
    // Should emit Failure if addLibraryVideosToDraftUseCase fails
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState when fails to retrieve videos from library',
      // arrange
      build: () {
        when(mockAddVideosToDraft
                .call(addVideosToDraft.Params(memory: tMemory)))
            .thenAnswer((_) async => const Left(MediaServiceFailure(
                message: 'Unable to retrieve media from library')));
        return bloc;
      },
      //act
      act: (bloc) => bloc.add(AddVideoClickedEvent(memory: tMemory)),
      //assert
      expect: () => [
        const MemoryManipulationFailureState(
          titleErrorMesssage: '',
          videoAddingErrorMesssage: 'Unable to retrieve media from library',
          savingErrorMesssage: '',
        ),
      ],
    );
  });
}
