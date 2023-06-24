import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/usecases/usecases.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class RetrieveVideoListFromLibraryUseCase
    implements UseCase<List<Video>, NoParams> {
  final MemoriesRepository repository;

  RetrieveVideoListFromLibraryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Video>>> call(NoParams params) async {
    return await repository.performRetrieveVideoListFromLibrary();
  }
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
