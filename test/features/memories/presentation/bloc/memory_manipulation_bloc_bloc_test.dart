import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart'
    as createMemory;
import 'package:griot_app/memories/domain/usecases/get_video_from_library_usecase.dart'
    as getVideo;
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';

import 'memory_manipulation_bloc_bloc_test.mocks.dart';

@GenerateMocks([
  createMemory.CreateMemoriesUseCase,
  getVideo.GetVideoFromLibraryUseCase,
])
void main() {
  late MemoryManipulationBlocBloc bloc;
  late MockCreateMemoriesUseCase mockCreateMemoriesUseCase;
  late MockGetVideoFromLibraryUseCase mockGetVideoFromLibraryUseCase;

  setUp(() {
    mockCreateMemoriesUseCase = MockCreateMemoriesUseCase();
    mockGetVideoFromLibraryUseCase = MockGetVideoFromLibraryUseCase();

    bloc = MemoryManipulationBlocBloc(
      createMemory: mockCreateMemoriesUseCase,
      getLibraryVideos: mockGetVideoFromLibraryUseCase,
    );
  });

  group('CreateMemoryEvent', () {
    const tTitle = '';
    const tMemory = Memory(title: tTitle, videos: null);

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryCreationSuccess state when memory creation is successful',
      build: () {
        when(mockCreateMemoriesUseCase
                .call(const createMemory.Params(title: tTitle)))
            .thenAnswer((_) async => const Right(tMemory));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateMemoryEvent(title: tTitle)),
      expect: () => [
        MemoryCreationBlocLoading(),
        const MemoryUpdateSuccessState(memory: tMemory),
      ],
    );

    blocTest<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      'should emit MemoryCreationFailure state when memory creation fails',
      build: () {
        when(mockCreateMemoriesUseCase
                .call(const createMemory.Params(title: tTitle)))
            .thenAnswer((_) async =>
                const Left(ServerFailure(message: 'Failed to create memory')));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateMemoryEvent(title: tTitle)),
      expect: () => [
        MemoryCreationBlocLoading(),
        MemoryCreationBlocFailure(),
      ],
    );
  });
}
