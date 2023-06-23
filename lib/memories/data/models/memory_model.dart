import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class MemoryModel extends Memory {
  MemoryModel({
    required super.id,
    required super.title,
    required super.videos,
    required super.accountId,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      accountId: json['account'],
      id: json['id'],
      title: json['title'],
      videos: (json['videos'] as List<dynamic>?)
              ?.map((videoJson) =>
                  VideoModel.fromJson(videoJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'account': accountId,
      'title': title,
      'videos': videos,
    };
  }
}
