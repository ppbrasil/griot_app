import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';

class VideoProcessingService {
  final MemoriesRemoteDataSource remoteDataSource;

  VideoProcessingService({required this.remoteDataSource});

  Future<void> deleteVideos({required List<Video> videos}) async {
    try {
      for (var video in videos) {
        await remoteDataSource.deleteVideoFromAPI(videoId: video.id!);
      }
    } on Exception {
      throw ServerException();
    }
  }

  Future<void> addVideos(
      {required int memoryId, required List<Video> videos}) async {
    try {
      for (var video in videos) {
        await remoteDataSource.postVideoToAPI(memoryId: memoryId, video: video);
      }
    } on Exception {
      throw ServerException();
    }
  }

  Future<void> processVideoChanges(
      Memory memory, Memory retrievedMemory) async {
    List<Video> memoryOriginalVideos = memory.videos ?? [];
    List<Video> memoryFinalVideos = retrievedMemory.videos ?? [];

    List<Video> videosToDelete =
        findMissingItems(memoryFinalVideos, memoryOriginalVideos);
    List<Video> videosToAdd =
        findMissingItems(memoryOriginalVideos, memoryFinalVideos);

    try {
      await deleteVideos(videos: videosToDelete);
    } on Exception {
      throw ServerException();
    }
    try {
      await addVideos(memoryId: memory.id!, videos: videosToAdd);
    } on Exception {
      throw ServerException();
    }
  }
}

/// Some Helpers function I'm not sure should be here
List<T> findMissingItems<T>(List<T> items, List<T> list) {
  final missingItems = <T>[];
  for (final item in items) {
    if (isItemMissing(item, list)) {
      missingItems.add(item);
    }
  }

  return missingItems;
}

bool isItemMissing<T>(T item, List<T> list) {
  bool isMissing = !list.contains(item);
  return isMissing;
}

List<T> assignOrCreateList<T>(List<T>? list) {
  return list ?? [];
}
