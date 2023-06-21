import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';
import 'package:griot_app/user/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final NetworkInfo networkInfo;
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(
      {required this.networkInfo, required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Account>>> performGetBelovedAccountsList() async {
    if (await networkInfo.isConnected) {
      try {
        List<Account> belovedAccountsList =
            await remoteDataSource.getBelovedAccountsListFromAPI();

        return Right(belovedAccountsList);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Account>>> performGetOwnedAccountsList() async {
    if (await networkInfo.isConnected) {
      try {
        final List<Account> belovedAccountsList =
            await remoteDataSource.getOwnedAccountsListFromAPI();

        remoteDataSource.storeMainAccountId(
            mainAccountId: belovedAccountsList[0].id);

        return Right(belovedAccountsList);
      } on ServerException {
        return const Left(ServerFailure(message: 'Unable to retrieve data'));
      }
    } else {
      return const Left(ConnectivityFailure(message: 'No internet connection'));
    }
  }
}
