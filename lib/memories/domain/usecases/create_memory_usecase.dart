import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class CreateMemoriesUseCase implements UseCase<Memory, Params> {
  final MemoriesRepository repository;

  CreateMemoriesUseCase(this.repository);

  @override
  Future<Either<Failure, Memory>> call(Params params) async {
    Memory memory = Memory(
        id: null,
        accountId: params.accountId,
        title: params.title,
        videos: params.videos);
    return await repository.performcreateMemory(
      memory: memory,
    );
  }
}

class Params extends Equatable {
  final int? id;
  final int accountId;
  final String? title;
  final List<Video>? videos;

  const Params({
    required this.id,
    required this.title,
    required this.accountId,
    required this.videos,
  });

  @override
  List<Object> get props => [];
}
