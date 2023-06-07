import 'package:dartz/dartz.dart';
import 'package:griot_app/authentication/domain/entities/token.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/authentication/domain/usecases/perform_login.dart';
import 'perform_login_test.mocks.dart';

@GenerateMocks([AuthRepository])

void main(){
  late PerformLogin usecase;
  late MockAuthRepository mockAuthRepository;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    usecase = PerformLogin(mockAuthRepository);

  });

  const tEmail = "ppbrasil";
  const tPassword = "Q!w2e3r4T%";
  const tToken = Token(tokenString: 'agivenstring');

  test(
    'should get a token from the auth credentials from the repository',
    () async {
      // arrange
      when(mockAuthRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tToken));

      // act
      final result = await usecase(email: tEmail, password: tPassword);

      // assert
      expect(result, const Right(tToken));
      verify(mockAuthRepository.login(tEmail, tPassword));    
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
  'should return failure when the call to login is unsuccessful',
  () async {
    // arrange
    const Failure failure = AuthenticationFailure(message: 'Authentication Failed');  // Or any other Failure you have defined
    when(mockAuthRepository.login(any, any))
        .thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(email: tEmail, password: tPassword);

    // assert
    expect(result, const Left(failure));
    verify(mockAuthRepository.login(tEmail, tPassword));    
    verifyNoMoreInteractions(mockAuthRepository);
  },
);

}