import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/create_memory_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_memory_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late CreateMemoriesUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = CreateMemoriesUseCase(mockMemoriesRepository);
  });

  const tTitle = "My Memory Title";
  const tAccountId = 1;
  Memory tNewMemory = Memory(
    title: tTitle,
    videos: [],
    accountId: tAccountId,
    id: null,
  );

  test('Should get a memory\'s details from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performCreateDraftMemoryLocally(
            accountId: tAccountId))
        .thenAnswer((_) async => Right(tNewMemory));

    // act
    final result = await usecase(const Params(
      title: tTitle,
      accountId: tAccountId,
      id: null,
      videos: [],
    ));

    // assert
    expect(result, equals(Right(tNewMemory)));
    verify(mockMemoriesRepository.performCreateDraftMemoryLocally(
        accountId: tAccountId));
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
