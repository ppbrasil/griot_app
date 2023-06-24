import 'package:dartz/dartz.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';
import 'package:griot_app/memories/domain/usecases/retrieve_video_list_from_library_usecase.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'retrieve_video_list_from_library_usecase_test.mocks.dart';

@GenerateMocks([MemoriesRepository])
void main() {
  late RetrieveVideoListFromLibraryUseCase usecase;
  late MockMemoriesRepository mockMemoriesRepository;

  setUp(() {
    mockMemoriesRepository = MockMemoriesRepository();
    usecase = RetrieveVideoListFromLibraryUseCase(mockMemoriesRepository);
  });

  List<VideoModel> tVideoModelList = [
    const VideoModel(file: 'myUrl1'),
    const VideoModel(file: 'myUrl2'),
  ];
  List<Video> tVideoList = tVideoModelList;

  test('Should get a List<Video> from the repository', () async {
    // arrange
    when(mockMemoriesRepository.performRetrieveVideoListFromLibrary())
        .thenAnswer((_) async => Right(tVideoModelList));
    // act
    final result = await usecase(const NoParams());
    // assert
    expect(result, equals(Right(tVideoList)));
    verify(mockMemoriesRepository.performRetrieveVideoListFromLibrary());
    verifyNoMoreInteractions(mockMemoriesRepository);
  });
}
