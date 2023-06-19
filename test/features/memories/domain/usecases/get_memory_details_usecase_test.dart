import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/get_memory_details_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_memory_details_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late GetMemoriesUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = GetMemoriesUseCase(mockMemoriesRepository);
  });

  const tMemoryId = 1;
  const tMemory = Memory(title: 'Memory 1');

  test('Should get a memory\'s detials from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performGetMemoryDetails(memoryId: tMemoryId))
        .thenAnswer((_) async => const Right(tMemory));
    // act
    final result = await usecase(const Params(memoryId: tMemoryId));
    // assert
    expect(result, equals(const Right(tMemory)));
    verify(mockMemoriesRepository.performGetMemoryDetails(memoryId: tMemoryId));
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
