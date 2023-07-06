import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:griot_app/user/data/data_sources/users_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UsersRemoteDataSource usersRemoteDataSource;

  AuthRepositoryImpl({
    required this.usersRemoteDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Token>> login({
    required String username,
    required String password,
  }) async {
    await networkInfo.isConnected;
    try {
      final remoteToken = await remoteDataSource.login(username, password);
      await remoteDataSource.storeTokenToSharedPreferences(remoteToken);
      List<Account> ownedAccountList =
          await usersRemoteDataSource.getOwnedAccountsListFromAPI();
      usersRemoteDataSource.storeMainAccountId(
          mainAccountId: ownedAccountList[0].id);
      return Right(remoteToken);
    } on InvalidTokenException {
      return const Left(InvalidTokenFailure(message: 'Invalid token'));
    } on ServerException {
      return const Left(ServerFailure(message: 'Authentication failed'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (!(await networkInfo.isConnected)) {
      return const Left(
          ConnectivityFailure(message: 'Internet is not available'));
    }
    try {
      final destroyed =
          await remoteDataSource.destroyTokenFromSharedPreferences();
      return Right(destroyed);
    } on InvalidTokenException {
      return const Left(InvalidTokenFailure());
    } on NetworkException {
      return const Left(
          ConnectivityFailure(message: 'Internet is not available'));
    }
  }
}
