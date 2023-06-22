import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/get_video_from_library_usecase.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_memory_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late GetVideoFromLibrary usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = GetVideoFromLibrary(mockMemoriesRepository);
  });

  const tVideo1 = Video(
      file: '/videos/myVideo1',
      id: 1,
      name: 'Video Name 1',
      memory: null,
      length: 36);
  const tVideo2 = Video(
      file: '/videos/myVideo2',
      id: 2,
      name: 'Video Name 2',
      memory: null,
      length: 12);
  const List<Video> tVideosList = [tVideo1, tVideo2];

  test('Should get a Video\'s details from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performGetVideoFromLibrary())
        .thenAnswer((_) async => const Right(tVideosList));
    // act
    final result = await usecase(const NoParams());
    // assert
    expect(result, equals(const Right(tVideosList)));
    verify(mockMemoriesRepository.performGetVideoFromLibrary());
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
