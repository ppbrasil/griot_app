import 'package:equatable/equatable.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';

class Video extends Equatable {
  final Memory memory;
  final String file;

  const Video({required this.memory, required this.file});

  @override
  List<Object> get props => [memory, file];
}
