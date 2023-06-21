import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/user/domain/repository/users_repository.dart';
import 'package:griot_app/user/domain/use_cases/get_user_owned_accounts_list_usecase.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_user_owned_accounts_list_usecase_test.mocks.dart';

@GenerateMocks([UsersRepository])
void main() {
  late GetOwnedAccountsListUseCase usecase;
  late MockUsersRepository mockUsersRepository;

  setUp(() {
    mockUsersRepository = MockUsersRepository();
    usecase = GetOwnedAccountsListUseCase(mockUsersRepository);
  });

  final tAccountList = [
    const Account(name: 'tAccountName1'),
    const Account(name: 'tAccountName2'),
  ];

  test('Should get list of memories from the repository', () async {
    // arrange
    when(mockUsersRepository.performGetOwnedAccountsList())
        .thenAnswer((_) async => Right(tAccountList));
    // act
    final result = await usecase(const NoParams());
    // assert
    expect(result, equals(Right(tAccountList)));
    verify(mockUsersRepository.performGetOwnedAccountsList());
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
