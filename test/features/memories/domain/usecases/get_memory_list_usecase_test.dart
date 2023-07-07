import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/get_memories_list_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_memory_list_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late GetMemoriesList usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = GetMemoriesList(mockMemoriesRepository);
  });

  const tAccountId = 1;
  final tMemoryList = [
    Memory(title: 'Memory 1', videos: const [], id: 1, accountId: tAccountId),
    Memory(title: 'Memory 2', videos: const [], id: 1, accountId: tAccountId),
  ];

  test('Should get list of memories from the repository', () async {
    // arrange
    when(mockMemoriesRepository.getMemoriesList())
        .thenAnswer((_) async => Right(tMemoryList));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, equals(Right(tMemoryList)));
    verify(mockMemoriesRepository.getMemoriesList());
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
