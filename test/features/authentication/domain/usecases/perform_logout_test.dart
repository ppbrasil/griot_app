import 'package:dartz/dartz.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/domain/usecases/perform_logout.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'perform_logout_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late PerformLogout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = PerformLogout(mockAuthRepository);
  });

  test(
    'should call lougout from repository and get true when called',
    () async {
      // arrange
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Right(true));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return failure when the call to logout is unsuccessful',
    () async {
      // arrange
      const Failure failure = AuthenticationFailure(message: 'Logout Failed');
      when(mockAuthRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
