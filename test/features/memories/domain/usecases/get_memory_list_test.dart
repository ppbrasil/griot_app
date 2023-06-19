import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/get_memories_list.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_memory_list_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late GetMemoriesList usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = GetMemoriesList(mockMemoriesRepository);
  });

  final tMemoryList = [
    const Memory(title: 'Memory 1'),
    const Memory(title: 'Memory 2'),
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
