import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/add_video_list_from_library_to_draft_memory_usecase.dart.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'add_video_list_from_library_to_draft_memory_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late AddVideoListFromLibraryToDraftMemoryUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase =
        AddVideoListFromLibraryToDraftMemoryUseCase(mockMemoriesRepository);
  });
  Memory tInitialMemory = Memory(
    id: null,
    title: 'My Tytle',
    accountId: 1,
    videos: const [],
  );

  List<VideoModel> tVideoModelList = [
    const VideoModel(file: 'myUrl1'),
    const VideoModel(file: 'myUrl2'),
  ];
  List<Video> tVideoList = tVideoModelList;

  Memory tFinalMemory = Memory(
    id: null,
    title: 'My Tytle',
    accountId: 1,
    videos: tVideoList,
  );

  test('Should get a List<Video> from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performAddVideoListFromLibraryToDraftMemory(
            memory: tInitialMemory))
        .thenAnswer((_) async => Right(tFinalMemory));
    // act
    final result = await usecase(Params(memory: tInitialMemory));
    // assert
    expect(result, equals(Right(tFinalMemory)));
    verify(mockMemoriesRepository.performAddVideoListFromLibraryToDraftMemory(
        memory: tInitialMemory));
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
