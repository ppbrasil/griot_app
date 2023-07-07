import 'package:dartz/dartz.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/domain/usecases/perform_check_logged_in_usecase.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check_logger_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late CheckLoggedInUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckLoggedInUseCase(mockAuthRepository);
  });

  test(
    'should get a token from localdata source when token is available',
    () async {
      // arrange
      const tTokenString = 'kyiuvoivbpoiyubpi';
      const tToken = Token(tokenString: tTokenString);
      when(mockAuthRepository.performCheckLoggedIn())
          .thenAnswer((_) async => const Right(tToken));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Right(tToken));
      verify(mockAuthRepository.performCheckLoggedIn());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'should return failure when the call to login is unsuccessful',
    () async {
      // arrange
      const Failure failure =
          InvalidTokenFailure(); // Or any other Failure you have defined
      when(mockAuthRepository.performCheckLoggedIn())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await usecase(const NoParams());

      // assert
      expect(result, const Left(failure));
      verify(mockAuthRepository.performCheckLoggedIn());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
