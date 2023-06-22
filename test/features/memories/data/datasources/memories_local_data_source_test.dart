import 'package:griot_app/core/data/media_service.dart';
import 'package:griot_app/memories/data/data_source/memories_local_data_source.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'memories_local_data_source_test.mocks.dart';

@GenerateMocks([MediaService])
void main() {
  late MemoriesLocalDataSourceImpl datasource;
  late MockMediaService mockMediaService;

  setUp(() {
    mockMediaService = MockMediaService();
    datasource = MemoriesLocalDataSourceImpl(mediaService: mockMediaService);
  });

  group('getVideosFromLibraryFromDevice', () {
    const VideoModel tVideoModel1 = VideoModel(
      id: 1,
      file: '/path/to/file/1',
      name: 'Video Name 1',
      memory: null,
    );

    const VideoModel tVideoModel2 = VideoModel(
      id: 2,
      file: '/path/to/file/2',
      name: 'Video Name 2',
      memory: null,
    );

    final tVideoModelList = [tVideoModel1, tVideoModel2];

    test(
      'Should return List<VideoModel> when selectiong is successful',
      () async {
        // arrange
        when(mockMediaService.getMultipleVideos())
            .thenAnswer((_) async => tVideoModelList);

        // act
        final result = await datasource.getVideosFromLibraryFromDevice();

        // assert
        verify(mockMediaService.getMultipleVideos());
        expect(result, equals(tVideoModelList));
      },
    );
    test(
      'Should throw a ServerException when selectiong is unsuccessful',
      () async {
        // arrange
        when(mockMediaService.getMultipleVideos())
            .thenThrow((_) async => Exception('No files selected'));

        // act
        final call = datasource.getVideosFromLibraryFromDevice;

        // assert
        expect(() => call(), throwsA(const TypeMatcher<Exception>()));
      },
    );
  });
}
