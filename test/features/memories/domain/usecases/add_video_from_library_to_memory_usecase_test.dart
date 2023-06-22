import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/add_video_from_library_to_memory_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'add_video_from_library_to_memory_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late AddVideoFromLibraryToMemoryUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = AddVideoFromLibraryToMemoryUseCase(mockMemoriesRepository);
  });

  const tTitle = 'My Title';
  const tMemory = Memory(title: tTitle, videos: null);

  test('Should get a memory\'s detials from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performAddVideoFromLibraryToMemory(
            memory: tMemory))
        .thenAnswer((_) async => const Right(tMemory));
    // act
    final result = await usecase(const Params(memory: tMemory));
    // assert
    expect(result, equals(const Right(tMemory)));
    verify(mockMemoriesRepository.performAddVideoFromLibraryToMemory(
        memory: tMemory));
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
