import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class Video extends Equatable {
  final int? id;
  final String file;
  final String? name;
  final int? memoryId;

  const Video({
    required this.id,
    required this.file,
    required this.name,
    required this.memoryId,
  });

  @override
  List<Object> get props => [file];
}
