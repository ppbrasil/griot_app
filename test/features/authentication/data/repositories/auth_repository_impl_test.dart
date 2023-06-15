import 'package:dartz/dartz.dart';
import 'package:griot_app/authentication/data/data_sources/auth_data_source.dart';
import 'package:griot_app/authentication/data/models/token_model.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/core/error/exceptions.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'auth_repository_impl_test.mocks.dart';

//class MockRemoteDataSource extends Mock implements AuthRemoteDataSource{}

//class MockNetworkInfo extends Mock implements NetworkInfo{}

@GenerateMocks([AuthRemoteDataSource, NetworkInfo, ServerException])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const tEmail = 'ppbrasil@gmail.com';
  const tPassword = 'q1w2e3r4t5';
  const tTokenModel = TokenModel(tokenString: 'q1w2io8yvoihpedvefdv');
  const Token tToken = tTokenModel;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('login', () {
//    setUp(() {
//      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//    });

    test(
      'should check if the device is online',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.login(tEmail, tPassword))
            .thenAnswer((_) async => tTokenModel);
        //act
        await repository.login(username: tEmail, password: tPassword);
        //assert
        verify(mockNetworkInfo.isConnected).called(1);
      },
    );
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return data when auth call to remote data source is successfull',
        () async {
      // arrange
      when(mockRemoteDataSource.login(tEmail, tPassword))
          .thenAnswer((_) async => tTokenModel);
      // act
      final result =
          await repository.login(username: tEmail, password: tPassword);
      // assert
      verify(mockRemoteDataSource.login(tEmail, tPassword));
      expect(result, equals(const Right(tToken)));
    });

    test(
        'should perssit token when auth call to remote data source is successfull',
        () async {
      // arrange
      when(mockRemoteDataSource.login(tEmail, tPassword))
          .thenAnswer((_) async => tTokenModel);
      // act
      await repository.login(username: tEmail, password: tPassword);
      // assert
      verify(mockRemoteDataSource.login(tEmail, tPassword));
      verify(mockRemoteDataSource.storeToken(tTokenModel));
    });
  });

  test(
      'should return Auth failure when auth call to remote data source is unsuccessfull',
      () async {
    // arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockRemoteDataSource.login(tEmail, tPassword))
        .thenThrow(ServerException());
    // act
    final result =
        await repository.login(username: tEmail, password: tPassword);
    // assert
    verify(mockRemoteDataSource.login(tEmail, tPassword));
    expect(result,
        equals(const Left(ServerFailure(message: 'Authentication failed'))));
  });
}
