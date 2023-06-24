import 'package:dartz/dartz.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/core/error/failures.dart';
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
  late MemoryManipulationBlocBloc bloc;
  late MockCreateMemoriesUseCase mockCreateMemoriesUseCase;
  late MockAddVideoFromLibraryToMemoryUseCase
      mockAddVideoFromLibraryToMemoryUseCase;
  late MockGetMemoriesUseCase mockGetMemoriesUseCase;
  late MockMainAccountIdProvider mockMainAccountIdProvider;

  setUp(() {
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
    );
  });

  group('CreateMemoryEvent', () {
    const tTitle = '';
    const tAccountId = 1;
    Memory tMemory = Memory(
      title: tTitle,
      videos: [],
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
      act: (bloc) =>
          bloc.add(const CreateMemoryEvent(title: tTitle, videos: [])),
      expect: () => [
        MemoryLoading(),
        MemorySuccessState(memory: tMemory),
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
      act: (bloc) =>
          bloc.add(const CreateMemoryEvent(title: tTitle, videos: [])),
      expect: () => [
        MemoryLoading(),
        MemoryCreationBlocFailure(),
      ],
    );
  });
}
