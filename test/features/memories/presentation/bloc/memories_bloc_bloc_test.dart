import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'package:griot_app/memories/domain/usecases/get_memories_list.dart'
    as getMemoriesUseCase;
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart'
    as getMemoryUseCase;

import 'memories_bloc_bloc_test.mocks.dart';

@GenerateMocks([
  getMemoriesUseCase.GetMemoriesList,
  getMemoryUseCase.GetMemoriesUseCase,
])
void main() {
  late MemoriesBlocBloc bloc;

  late MockGetMemoriesList mockGetMemoriesListUseCase;
  late MockGetMemoriesUseCase mockGetMemoryUseCase;

  setUp(() {
    mockGetMemoriesListUseCase = MockGetMemoriesList();
    mockGetMemoryUseCase = MockGetMemoriesUseCase();
    bloc = MemoriesBlocBloc(
      getMemory: mockGetMemoryUseCase,
      getMemories: mockGetMemoriesListUseCase,
    );
  });

  test('Initial state should be Empty', () {
    expect(bloc.state, equals(MemoriesInitial()));
  });

  group('GetMemoryDetailsEvent', () {
    const tMemoryId = 1;
    const tAccountId = 1;
    const tMemory = Memory(
      title: "My memory",
      videos: [],
      accountId: tAccountId,
      id: tMemoryId,
    );

    blocTest<MemoriesBlocBloc, MemoriesBlocState>(
      'should emit MemoryGetDetailsSuccess state when memory details retrieval is successful',
      build: () {
        when(mockGetMemoryUseCase
                .call(const getMemoryUseCase.Params(memoryId: tMemoryId)))
            .thenAnswer(
          (_) async => const Right(tMemory),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetMemoryDetailsEvent(memoryId: tMemoryId)),
      expect: () => [
        MemoryGetDetailsLoading(),
        const MemoryGetDetailsSuccess(memory: tMemory),
      ],
    );

    blocTest<MemoriesBlocBloc, MemoriesBlocState>(
      'should emit MemoryGetDetailsFailure state when memory details retrieval fails',
      build: () {
        when(mockGetMemoryUseCase
                .call(const getMemoryUseCase.Params(memoryId: tMemoryId)))
            .thenAnswer(
          (_) async => const Left(
              ServerFailure(message: 'Failed to fetch memory details')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const GetMemoryDetailsEvent(memoryId: tMemoryId)),
      expect: () => [
        MemoryGetDetailsLoading(),
        const MemoryGetDetailsFailure(
            message: 'Failed to fetch memory details'),
      ],
    );
  });

  group('GetMemoriesListEvent', () {
    const tMemoryId1 = 1;
    const tMemoryId2 = 2;
    const tAccountId = 1;
    const tMemory1 = Memory(
      title: "My memory",
      videos: [],
      accountId: tAccountId,
      id: tMemoryId1,
    );
    const tMemory2 = Memory(
      title: "My other memory",
      videos: [],
      accountId: tAccountId,
      id: tMemoryId2,
    );
    final tMemoryList = [tMemory1, tMemory2];

    blocTest<MemoriesBlocBloc, MemoriesBlocState>(
      'should emit MemoriesGetListSuccess state when memory list retrieval is successful',
      build: () {
        when(mockGetMemoriesListUseCase.call(getMemoriesUseCase.NoParams()))
            .thenAnswer((_) async => Right(tMemoryList));
        return bloc;
      },
      act: (bloc) => bloc.add(GetMemoriesListEvent()),
      expect: () => [
        MemoriesGetListLoading(),
        MemoriesGetListSuccess(memories: tMemoryList),
      ],
    );

    blocTest<MemoriesBlocBloc, MemoriesBlocState>(
      'should emit MemoriesGetListFailure state when memory list retrieval fails',
      build: () {
        when(mockGetMemoriesListUseCase.call(getMemoriesUseCase.NoParams()))
            .thenAnswer((_) async => const Left(
                ServerFailure(message: 'Failed to fetch memory list')));
        return bloc;
      },
      act: (bloc) => bloc.add(GetMemoriesListEvent()),
      expect: () => [
        MemoriesGetListLoading(),
        const MemoriesGetListFailure(message: 'Failed to fetch memory list'),
      ],
    );
  });
}
