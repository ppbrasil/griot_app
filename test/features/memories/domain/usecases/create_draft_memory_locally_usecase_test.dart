import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/create_draft_memory_locally_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_draft_memory_locally_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late CreateDraftMemoryLocallyUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = CreateDraftMemoryLocallyUseCase(mockMemoriesRepository);
  });

  int tAccountId = 1;
  Memory tNewMemory = Memory(
    accountId: tAccountId,
    id: null,
    title: null,
    videos: [],
  );

  test('Should get a black memory from repository', () async {
    // arrange
    when(mockMemoriesRepository.performCreateDraftMemoryLocally(
            accountId: tAccountId))
        .thenAnswer((_) async => Right(tNewMemory));

    // act
    final result = await usecase(Params(accountId: tAccountId));

    // assert
    expect(result, equals(Right(tNewMemory)));
    verify(mockMemoriesRepository.performCreateDraftMemoryLocally(
        accountId: tAccountId));
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
