import 'package:dartz/dartz.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';

import 'package:griot_app/accounts/data/data_sources/accounts_remote_data_source.dart';
import 'package:griot_app/accounts/data/models/account_model.dart';
import 'package:griot_app/accounts/data/models/beloved_one_model.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final NetworkInfo networkInfo;
  final AccountsRemoteDataSource remoteDataSource;

  AccountsRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, AccountModel>> performGetAccountDetails(
      {required int accountId}) async {
    if (await networkInfo.isConnected) {
      try {
        AccountModel myAccount = await remoteDataSource
            .getAccountDetailsFromAPI(accountId: accountId);

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
      {required int belovedOneId}) async {
    if (await networkInfo.isConnected) {
      try {
        BelovedOneModel myBeloved = await remoteDataSource
            .getBelovedOneDetailsFromAPI(belovedOneid: belovedOneId);

        return Right(myBeloved);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<BelovedOneModel>>> performGetBelovedOnesList(
      {required int accountId}) async {
    if (await networkInfo.isConnected) {
      try {
        List<BelovedOneModel> myBelovedList = await remoteDataSource
            .getBelovedOnesListFromAPI(accountId: accountId);

        return Right(myBelovedList);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
