import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int? id;
  final String file;
  final String? thumbnail;
  final String? name;
  final int? memoryId;

  const Video({
    required this.id,
    required this.file,
    required this.thumbnail,
    required this.name,
    required this.memoryId,
  });

  @override
  List<Object?> get props => [id, file, name, memoryId];
}
