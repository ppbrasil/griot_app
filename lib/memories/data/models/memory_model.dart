import 'package:griot_app/memories/data/models/video_model.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class MemoryModel extends Memory {
  final int account;

  const MemoryModel({
    required super.id,
    required this.account,
    required super.title,
    required super.videos,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      account: json['account'],
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
      'account': account,
      'title': title,
      'videos': videos,
    };
  }
}
