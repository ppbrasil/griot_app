import 'package:griot_app/memories/data/models/video_model.dart';

abstract class MediaService {
  Future<List<VideoModel>?> getMultipleVideos();
  Future<VideoModel>? recordVideoFromCamera();
}

class MediaServiceImpl implements MediaService {
  @override
  Future<List<VideoModel>?> getMultipleVideos() async {
    throw Exception('No files selected');
  }

  @override
  Future<VideoModel>? recordVideoFromCamera() {
    throw Exception('No files recorded');
  }
}
