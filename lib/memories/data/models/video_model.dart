import 'package:griot_app/memories/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    super.id,
    required super.file,
    super.name,
    super.memoryId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      file: json['url'],
      name: json['name'],
      memoryId: json['memory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': file,
      'name': name,
      'memory': memoryId,
    };
  }
}
