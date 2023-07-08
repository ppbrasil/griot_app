import 'dart:typed_data';

import 'package:griot_app/core/services/thumbnail_services.dart';
import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class MediaService {
  Future<List<VideoModel>?> getMultipleVideos();
  Future<VideoModel>? recordVideoFromCamera();
}

class MediaServiceImpl implements MediaService {
  final ImagePicker imagePicker;
  final ThumbnailService thumbnailService;

  MediaServiceImpl({
    required this.imagePicker,
    required this.thumbnailService,
  });

  @override
  Future<List<VideoModel>?> getMultipleVideos() async {
    try {
      final List<XFile> selectedImages = await imagePicker.pickMultipleMedia();
      if (selectedImages.isNotEmpty) {
        return Future.wait(selectedImages.map((file) async {
          // Generate the thumbnail for the file
          final Uint8List? thumbnailData =
              await thumbnailService.generateThumbnail(videoUrl: file.path);

          return VideoModel(
            id: null,
            file: file.path,
            thumbnail: null,
            thumbnailData: thumbnailData,
            memoryId: null,
            name: file.name,
          );
        }));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<VideoModel>? recordVideoFromCamera() {
    throw Exception('No files recorded');
  }
}
