import 'dart:typed_data';
import 'package:video_compress/video_compress.dart';

abstract class ThumbnailService {
  Future<Uint8List?> generateThumbnail({required String videoUrl});
}

class VideoCompressThumbnailService implements ThumbnailService {
  @override
  Future<Uint8List?> generateThumbnail({required String videoUrl}) async {
    final bytes = await VideoCompress.getByteThumbnail(videoUrl,
        quality:
            50, // Set the quality of the thumbnail. The value should be between 1 and 100. Higher value means higher quality.
        position: -1 // Use -1 to get the thumbnail at the end of the video.
        );
    return bytes;
  }
}
