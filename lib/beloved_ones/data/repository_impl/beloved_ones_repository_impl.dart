import 'package:dartz/dartz.dart';
import 'package:griot_app/beloved_ones/data/data_sources/beloved_ones_remote_data_source.dart';
import 'package:griot_app/beloved_ones/data/models/beloved_one_model.dart';
import 'package:griot_app/beloved_ones/domain/entities/beloved_one.dart';
import 'package:griot_app/beloved_ones/domain/repositories/beloved_one_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';

class BelovedOnesRepositoryImpl implements BelovedOnesRepository {
  final NetworkInfo networkInfo;
  final BelovedOnesRemoteDataSource remoteDataSource;

  BelovedOnesRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BelovedOne>>> performGeBelovedOnesList() async {
    if (await networkInfo.isConnected) {
      try {
        List<BelovedOne> tBelovedOnesList =
            await remoteDataSource.getBelovedOnesListFromAPI();

        return Right(tBelovedOnesList);
      } on ServerFailure {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
