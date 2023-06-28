import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

class Memory extends Equatable {
  final int? id;
  final int accountId;
  final String? title;
  final List<Video>? videos;

  Memory({
    required this.id,
    required this.title,
    required this.accountId,
    required this.videos,
  });

  Memory copyWith({
    int? id,
    int? accountId,
    String? title,
    List<Video>? videos,
  }) {
    return Memory(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object?> get props => [id, accountId, title, videos];
}
