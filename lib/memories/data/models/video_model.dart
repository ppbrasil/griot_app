import 'package:griot_app/memories/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.file,
    required super.name,
    required super.memory,
  });
}
