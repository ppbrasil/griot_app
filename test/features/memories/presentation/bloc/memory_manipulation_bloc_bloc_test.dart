import 'package:dartz/dartz.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/services/field_validation.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/usecases/add_video_list_from_library_to_draft_memory_usecase.dart'
    as addVideosToDraft;
import 'package:griot_app/memories/domain/usecases/commit_changes_to_memory_usecase.dart'
    as commitMemoryUseCase;
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemory;
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
  getMemoryDetails.GetMemoriesUseCase,
  addVideosToDraft.AddVideoListFromLibraryToDraftMemoryUseCase,
  commitMemoryUseCase.CommitChangesToMemoryUseCase
])
void main() {
  late ValidationService validator;
  late MemoryManipulationBlocBloc bloc;
  late MockCreateMemoriesUseCase mockCreateMemoriesUseCase;
  late MockGetMemoriesUseCase mockGetMemoriesUseCase;
  late MockCommitChangesToMemoryUseCase mockCommitChangesToMemoryUseCase;
  late MockMainAccountIdProvider mockMainAccountIdProvider;
  late MockAddVideoListFromLibraryToDraftMemoryUseCase
      mockAddVideosToDraftUseCase;

  setUp(() {
    // Other dependencies
    mockMainAccountIdProvider = MockMainAccountIdProvider();
    validator = ValidationService();
    // UseCases
    mockCreateMemoriesUseCase = MockCreateMemoriesUseCase();
    mockAddVideosToDraftUseCase =
        MockAddVideoListFromLibraryToDraftMemoryUseCase();
    mockGetMemoriesUseCase = MockGetMemoriesUseCase();
    mockCommitChangesToMemoryUseCase = MockCommitChangesToMemoryUseCase();

    bloc = MemoryManipulationBlocBloc(
        accountIdProvider: mockMainAccountIdProvider,
        validationService: validator,
        //UseCases
        createMemory: mockCreateMemoriesUseCase,
        addVideosToDraft: mockAddVideosToDraftUseCase,
        getMemoryDetails: mockGetMemoriesUseCase,
        commitMemory: mockCommitChangesToMemoryUseCase);
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
        const MemoryLoading(memory: null),
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
        const MemoryLoading(memory: null),
        const MemoryCreationBlocFailure(memory: null),
      ],
    );
  });

  group('MemoryTitleChangedEvent', () {
    const tPreviousTitle = null;
    const tValidTitle = 'This is a valid title';
    const tShortTitle = '1234567';
    const tLogTitle =
        'This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. This is a long title. ';

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
      seed: () => MemoryManipulationSuccessState(memory: tOriginalMemory),
      //act

      act: (bloc) => bloc.add(const MemoryTitleChangedEvent(
        title: tValidTitle,
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
      seed: () => MemoryManipulationSuccessState(memory: tOriginalMemory),
      //act
      act: (bloc) => bloc.add(const MemoryTitleChangedEvent(
        title: '',
      )),
      //assert
      expect: () => [
        MemoryManipulationFailureState(
          memory: bloc.state.memory,
          titleErrorMesssage: 'Please enter a title for your memory',
          videoAddingErrorMesssage: '',
          savingErrorMesssage: '',
        ),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState state when title is toos short',
      // arrange
      build: () => bloc,
      seed: () => MemoryManipulationSuccessState(memory: tOriginalMemory),

      //act
      act: (bloc) => bloc.add(const MemoryTitleChangedEvent(
        title: tShortTitle,
      )),
      //assert
      expect: () => [
        MemoryManipulationFailureState(
          memory: bloc.state.memory,
          titleErrorMesssage: 'Titles must have at least 8 characters',
          videoAddingErrorMesssage: '',
          savingErrorMesssage: '',
        ),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState state when title is toos long',
      // arrange
      build: () => bloc,
      //act
      seed: () => MemoryManipulationSuccessState(memory: tOriginalMemory),

      act: (bloc) => bloc.add(const MemoryTitleChangedEvent(
        title: tLogTitle,
      )),
      //assert
      expect: () => [
        MemoryManipulationFailureState(
          memory: bloc.state.memory,
          titleErrorMesssage: 'Titles can\'t have more then 255 characters',
          videoAddingErrorMesssage: '',
          savingErrorMesssage: '',
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
      thumbnailData: null,
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
        when(mockAddVideosToDraftUseCase
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
        when(mockAddVideosToDraftUseCase
                .call(addVideosToDraft.Params(memory: tMemory)))
            .thenAnswer((_) async => const Left(MediaServiceFailure(
                message: 'Unable to retrieve media from library')));
        return bloc;
      },
      //act
      act: (bloc) => bloc.add(AddVideoClickedEvent(memory: tMemory)),
      //assert
      expect: () => [
        MemoryManipulationFailureState(
          memory: bloc.state.memory,
          titleErrorMesssage: '',
          videoAddingErrorMesssage: 'Unable to retrieve media from library',
          savingErrorMesssage: '',
        ),
      ],
    );
  });

  group('GetMemoryDetailsEvent', () {
    const tTitle = '';
    const tAccountId = 1;
    const tMemoryId = 1;
    Memory tMemory = Memory(
      id: tMemoryId,
      accountId: tAccountId,
      title: tTitle,
      videos: const [],
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationSuccessState state when memory retrieval is successful',
      build: () {
        when(mockGetMemoriesUseCase
                .call(const getMemoryDetails.Params(memoryId: tMemoryId)))
            .thenAnswer((_) async => Right(tMemory));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetMemoryDetailsEvent(memoryId: tMemoryId)),
      expect: () => [
        const MemoryLoading(memory: null),
        MemoryManipulationSuccessState(memory: tMemory),
      ],
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState when fails to retrieve memory from API',
      build: () {
        when(mockGetMemoriesUseCase
                .call(const getMemoryDetails.Params(memoryId: tMemoryId)))
            .thenAnswer((_) async =>
                const Left(ServerFailure(message: 'Unable to retrieve data')));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetMemoryDetailsEvent(memoryId: tMemoryId)),
      expect: () => [
        const MemoryLoading(memory: null),
        MemoryRetrievalFailureState(memory: bloc.state.memory),
      ],
    );
  });

  group('CommitMemoryEvent', () {
    // Define needed variables
    int tAccoountId = 1;
    int tMemoryId = 1;

    Memory tOriginalSimpleDraftMemory = Memory(
      accountId: tAccoountId,
      id: null,
      title: 'My Title',
      videos: const [],
    );

    Memory tReturningSimpleMemory = Memory(
      accountId: tAccoountId,
      id: tMemoryId,
      title: 'My Title',
      videos: const [],
    );

    Memory tOriginalCompleteDraftMemory = Memory(
      accountId: tAccoountId,
      id: null,
      title: 'My Title',
      videos: [
        Video(
          id: null,
          file: 'path1',
          thumbnail: 'thumbnail1',
          name: 'Video Name1',
          memoryId: tMemoryId,
          thumbnailData: null,
        ),
        Video(
          id: null,
          file: 'path2',
          thumbnail: 'thumbnail2',
          name: 'Video Name2',
          memoryId: tMemoryId,
          thumbnailData: null,
        ),
      ],
    );

    Memory tReturningCompleteMemory = Memory(
      accountId: tAccoountId,
      id: 1,
      title: 'My Title',
      videos: [
        Video(
          id: 1,
          file: 'path1',
          thumbnail: 'thumbnail1',
          name: 'Video Name1',
          memoryId: tMemoryId,
          thumbnailData: null,
        ),
        Video(
          id: 2,
          file: 'path2',
          thumbnail: 'thumbnail2',
          name: 'Video Name2',
          memoryId: tMemoryId,
          thumbnailData: null,
        ),
      ],
    );

    // Implement bloctest scenarios
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationSuccessState when succefully commiting a memory with only a title to API',
      // arrange
      build: () {
        when(mockCommitChangesToMemoryUseCase.call(
                commitMemoryUseCase.Params(memory: tOriginalSimpleDraftMemory)))
            .thenAnswer((_) async => Right(tReturningSimpleMemory));
        return bloc;
      },
      //act
      act: (bloc) =>
          bloc.add(CommitMemoryEvent(memory: tOriginalSimpleDraftMemory)),
      //assert
      expect: () => [
        MemoryManipulationSuccessState(memory: tReturningSimpleMemory),
      ],
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationSuccessState when succefully commiting a memory with title AND VIDEO to API',
      // arrange
      build: () {
        when(mockCommitChangesToMemoryUseCase.call(commitMemoryUseCase.Params(
                memory: tOriginalCompleteDraftMemory)))
            .thenAnswer((_) async => Right(tReturningCompleteMemory));
        return bloc;
      },
      //act
      act: (bloc) =>
          bloc.add(CommitMemoryEvent(memory: tOriginalCompleteDraftMemory)),
      //assert
      expect: () => [
        MemoryManipulationSuccessState(memory: tReturningCompleteMemory),
      ],
    );
    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryManipulationFailureState when failed commiting a memory to API',
      // arrange
      build: () {
        when(mockCommitChangesToMemoryUseCase.call(commitMemoryUseCase.Params(
                memory: tOriginalCompleteDraftMemory)))
            .thenAnswer((_) async => const Left(
                ServerFailure(message: 'Unable to Delete Videos from Memory')));
        return bloc;
      },
      //act
      act: (bloc) =>
          bloc.add(CommitMemoryEvent(memory: tOriginalCompleteDraftMemory)),
      //assert
      expect: () => [
        MemoryManipulationFailureState(
          savingErrorMesssage: 'Unable to save changes',
          titleErrorMesssage: '',
          videoAddingErrorMesssage: '',
          memory: bloc.state.memory,
        ),
      ],
    );
  });
}
