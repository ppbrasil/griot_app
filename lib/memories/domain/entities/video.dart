import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class Video extends Equatable {
  final int? id;
  final String file;
  final String? name;
  final Memory? memory;
  final int? length;

  const Video(
      {required this.id,
      required this.file,
      required this.name,
      required this.memory,
      required this.length});

  @override
  List<Object> get props => [file];
}
