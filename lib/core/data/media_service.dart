import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class MediaService {
  Future<List<VideoModel>?> getMultipleVideos();
  Future<VideoModel>? recordVideoFromCamera();
}

class MediaServiceImpl implements MediaService {
  final ImagePicker imagePicker;

  MediaServiceImpl({
    required this.imagePicker,
  });

  @override
  Future<List<VideoModel>?> getMultipleVideos() async {
    try {
      final List<XFile> selectedImages = await imagePicker.pickMultipleMedia();
      if (selectedImages.isNotEmpty) {
        return Future.wait(selectedImages.map((file) async => VideoModel(
              file: file.path,
              id: null,
              memoryId: null,
              name: file.name,
            )));
      }
      return null;
    } on Exception {
      return null;
    }
  }

  @override
  Future<VideoModel>? recordVideoFromCamera() {
    throw Exception('No files recorded');
  }
}
