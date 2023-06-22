import 'package:griot_app/core/data/media_service.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'media_service_test.mocks.dart';

@GenerateMocks([ImagePicker])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockImagePicker myImagePicker = MockImagePicker();
  MediaService mediaService = MediaServiceImpl(imagePicker: myImagePicker);

  group('getMultipleVideos', () {
    String tName1 = 'Video Name 1';
    String tName2 = 'Video Name 1';
    String tFile1 = '/path/to/file/1';
    String tFile2 = '/path/to/file/2';
    VideoModel tVideoModel1 = VideoModel(
      id: null,
      file: tFile1,
      name: tName1,
      memoryId: null,
    );
    VideoModel tVideoModel2 = VideoModel(
      id: null,
      file: tFile2,
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
      // act
      final result = await mediaService.getMultipleVideos();
      // assert
      verify(myImagePicker.pickMultipleMedia());
      expect(result, tVideoModelList);
    });
  });
}
