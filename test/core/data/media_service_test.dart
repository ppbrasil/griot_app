import 'dart:math';
import 'dart:typed_data';

import 'package:griot_app/core/data/media_service.dart';
import 'package:griot_app/core/services/thumbnail_services.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'media_service_test.mocks.dart';

@GenerateMocks([ImagePicker, ThumbnailService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockImagePicker myImagePicker = MockImagePicker();
  MockThumbnailService mockThumbnailService = MockThumbnailService();
  MediaService mediaService = MediaServiceImpl(
    imagePicker: myImagePicker,
    thumbnailService: mockThumbnailService,
  );

  group('getMultipleVideos', () {
    String tName1 = '1';
    String tName2 = '2';
    String tFile1 = '/path/to/file/1';
    String tFile2 = '/path/to/file/2';

    List<int> tRandomBytes1 =
        List<int>.generate(500, (_) => Random().nextInt(256));
    final tThumbnailData1 = Uint8List.fromList(tRandomBytes1);

    List<int> tRandomBytes2 =
        List<int>.generate(500, (_) => Random().nextInt(256));
    final tThumbnailData2 = Uint8List.fromList(tRandomBytes2);

    List<Uint8List> generateThumbnailResponses = [
      tThumbnailData1,
      tThumbnailData2
    ];

    VideoModel tVideoModel1 = VideoModel(
      id: null,
      file: tFile1,
      thumbnail: null,
      thumbnailData: tThumbnailData1,
      name: tName1,
      memoryId: null,
    );
    VideoModel tVideoModel2 = VideoModel(
      id: null,
      file: tFile2,
      thumbnail: null,
      thumbnailData: tThumbnailData2,
      name: tName2,
      memoryId: null,
    );
    final tVideoModelList = [tVideoModel1, tVideoModel2];
    final tXFile1 = XFile(tFile1, name: tName1);
    final tXFile2 = XFile(tFile2, name: tName2);
    final tXFileList = [tXFile1, tXFile2];

    test('Should return a List<VideoModel> when successfulled called',
        () async {
      // arrange
      when(myImagePicker.pickMultipleMedia())
          .thenAnswer((_) async => tXFileList);
      when(mockThumbnailService.generateThumbnail(
              videoUrl: anyNamed('videoUrl')))
          .thenAnswer((_) async => generateThumbnailResponses.removeAt(0));

      // act
      final result = await mediaService.getMultipleVideos();

      // assert
      verify(myImagePicker.pickMultipleMedia());
      expect(result, tVideoModelList);
    });
  });
}
