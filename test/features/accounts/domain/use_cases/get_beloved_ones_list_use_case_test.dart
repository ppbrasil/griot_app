import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/repositories/accounts_repository.dart';
import 'package:griot_app/accounts/domain/use_cases/get_beloved_ones_list_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_account_details_usecase_test.mocks.dart';

@GenerateMocks([AccountsRepository])
void main() {
  late GetBelovedOnesListUseCase usecase;
  late MockAccountsRepository mockBelovedOnesRepository;
  late int tAccountId = 1;

  setUp(() {
    mockBelovedOnesRepository = MockAccountsRepository();
    usecase = GetBelovedOnesListUseCase(mockBelovedOnesRepository);
  });

  const BelovedOne tBelovedOne1 = BelovedOne();
  const BelovedOne tBelovedOne2 = BelovedOne();
  const List<BelovedOne> tBelovedOnesList = [tBelovedOne1, tBelovedOne2];

  test('Should get a memory\'s details from the repository', () async {
    // arrange
    when(mockBelovedOnesRepository.performGetBelovedOnesList(
            accountId: tAccountId))
        .thenAnswer((_) async => const Right(tBelovedOnesList));

    // act
    final result = await usecase(Params(accountId: tAccountId));

    // assert
    expect(result, equals(const Right(tBelovedOnesList)));
    verify(mockBelovedOnesRepository.performGetBelovedOnesList(
        accountId: tAccountId));
    verifyNoMoreInteractions(mockBelovedOnesRepository);
  });
}
