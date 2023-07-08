import 'package:griot_app/core/data/media_service.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/memories/data/models/video_model.dart';

abstract class MemoriesLocalDataSource {
  Future<List<VideoModel>?> getVideosFromLibraryFromDevice();
}

class MemoriesLocalDataSourceImpl implements MemoriesLocalDataSource {
  final MediaService mediaService;

  MemoriesLocalDataSourceImpl({required this.mediaService});

  @override
  Future<List<VideoModel>?> getVideosFromLibraryFromDevice() async {
    try {
      final List<VideoModel>? files = await mediaService.getMultipleVideos();

      return files;
    } catch (e) {
      throw MediaServiceException();
    }
  }
}
