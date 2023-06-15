import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:griot_app/core/network/network_info.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
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
      remoteDataSource.storeToken(remoteToken);
      return Right(remoteToken);
    } on InvalidTokenException {
      return const Left(InvalidTokenFailure(message: 'Invalid token'));
    } on ServerException {
      return const Left(ServerFailure(message: 'Authentication failed'));
    }
  }
}
