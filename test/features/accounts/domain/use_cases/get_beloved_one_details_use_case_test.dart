import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/accounts/domain/use_cases/get_beloved_one_details_usecase.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_beloved_one_details_use_case_test.mocks.dart';

@GenerateMocks([AccountsRepository])
void main() {
  late GetBelovedOneDetailsUseCase usecase;
  late MockAccountsRepository mockAccountsRepository;

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    usecase = GetBelovedOneDetailsUseCase(mockAccountsRepository);
  });

  const BelovedOne tBelovedOne = BelovedOne();
  const tBelovedOneId = 1;

  test('Should get a BelovedOne\'s details from the repository', () async {
    // arrange
    when(mockAccountsRepository.performGetBelovedOneDetails(
            belovedOneId: tBelovedOneId))
        .thenAnswer((_) async => const Right(tBelovedOne));
    // act
    final result = await usecase(const Params(belovedOneId: tBelovedOneId));
    // assert
    expect(result, equals(const Right(tBelovedOne)));
    verify(mockAccountsRepository.performGetBelovedOneDetails(
        belovedOneId: tBelovedOneId));
    verifyNoMoreInteractions(mockAccountsRepository);
  });
}
