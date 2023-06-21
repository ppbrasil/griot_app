import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/data/data_sources/accounts_remote_data_source.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/core/error/exceptions.dart';

import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final NetworkInfo networkInfo;
  final AccountsRemoteDataSource remoteDataSource;

  AccountsRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, Account>> performGetAccountDetails(
      {int? accountId}) async {
    if (await networkInfo.isConnected) {
      try {
        Account myAccount = await remoteDataSource.getAccountDetailsFromAPI();

        return Right(myAccount);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, BelovedOne>> performGetBelovedOneDetails(
      {required int? belovedOneId}) async {
    if (await networkInfo.isConnected) {
      try {
        BelovedOne myBeloved =
            await remoteDataSource.getBelovedOneDetailsFromAPI();

        return Right(myBeloved);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BelovedOne>>> performGetBelovedOnesList(
      {required int? accountId}) async {
    if (await networkInfo.isConnected) {
      try {
        List<BelovedOne> myBelovedList =
            await remoteDataSource.getBelovedOnesListFromAPI();

        return Right(myBelovedList);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
