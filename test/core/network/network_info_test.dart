import 'package:griot_app/core/data/core_repository_impl.dart';
import 'package:griot_app/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker, CoreRepositoryImpl])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late MockCoreRepositoryImpl mockCoreRepositoryImpl;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    mockCoreRepositoryImpl = MockCoreRepositoryImpl();
    networkInfo = NetworkInfoImpl(
        coreRepository: mockCoreRepositoryImpl,
        internetConnectionChecker: mockInternetConnectionChecker);
  });

  group('IsConnected', () {
    test('Should forward the call to InternetConnectionChecker.hasConnection.',
        () async {
      // arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, true);
    });
    test(
        'Should call performNotifyNoInternetConnection and return false when hasConnection is false.',
        () async {
      // arrange
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      when(mockCoreRepositoryImpl.performNotifyNoInternetConnection())
          .thenAnswer((_) async => true);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(mockInternetConnectionChecker.hasConnection).called(1);
      verify(mockCoreRepositoryImpl.performNotifyNoInternetConnection())
          .called(1);
      expect(result, false);
    });
  });
}
