import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/accounts/domain/repository/accounts_repository.dart';
import 'package:griot_app/accounts/domain/use_cases/get_account_details_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_account_details_usecase_test.mocks.dart';

@GenerateMocks([AccountsRepository])
void main() {
  late GetAccountsDetails usecase;
  late MockAccountsRepository mockAccountsRepository;

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    usecase = GetAccountsDetails(mockAccountsRepository);
  });

  const tAccounId = 1;
  const tAccount = Account(name: 'My Account');

  test('Should get an Account\'s details from the repository', () async {
    // arrange
    when(mockAccountsRepository.performGetAccountDetails(accountId: tAccounId))
        .thenAnswer((_) async => const Right(tAccount));
    // act
    final result = await usecase(const Params(accountId: tAccounId));
    // assert
    expect(result, equals(const Right(tAccount)));
    verify(
        mockAccountsRepository.performGetAccountDetails(accountId: tAccounId));
    verifyNoMoreInteractions(mockAccountsRepository);
  });
}
