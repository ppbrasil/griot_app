import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/video.dart';

class Memory extends Equatable {
  final int? id;
  final String title;
  final List<Video>? videos;

  const Memory({this.id, required this.title, required this.videos});

  @override
  List<Object> get props => [title];
}
