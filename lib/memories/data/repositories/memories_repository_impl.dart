import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/memories/data/data_source/memories_remote_data_source.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/domain/repositories/memories_repository.dart';

class MemoriesRepositoryImpl implements MemoriesRepository {
  final NetworkInfo networkinfo;
  final MemoriesRemoteDataSource remoteDataSource;

  MemoriesRepositoryImpl(
      {required this.networkinfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Memory>>> getMemoriesList() async {
    if (await networkinfo.isConnected) {
      try {
        final List<Memory> memories =
            await remoteDataSource.getMemoriesListFromAPI();
        return Right(memories);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performGetMemoryDetails(
      {required int memoryId}) async {
    if (await networkinfo.isConnected) {
      try {
        final Memory memory =
            await remoteDataSource.getMemoryDetailsFromAPI(memoryId: memoryId);
        return Right(memory);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Memory>> performcreateMemory(
      {required String title}) async {
    if (await networkinfo.isConnected) {
      try {
        final Memory memory =
            await remoteDataSource.postMemoryToAPI(title: title);
        return Right(memory);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
