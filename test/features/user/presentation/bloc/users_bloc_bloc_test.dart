import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';
import 'package:griot_app/user/domain/use_cases/get_user_owned_accounts_list_usecase.dart';
import 'package:griot_app/user/presentation/bloc/users_bloc_bloc.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';

import 'users_bloc_bloc_test.mocks.dart';

@GenerateMocks([GetOwnedAccountsListUseCase, MainAccountIdProvider])
void main() {
  late UsersBlocBloc bloc;
  late MockGetOwnedAccountsListUseCase mockGetBelovedOnesListUseCase;

  setUp(() {
    mockGetBelovedOnesListUseCase = MockGetOwnedAccountsListUseCase();
    bloc = UsersBlocBloc(getOwnedAccounts: mockGetBelovedOnesListUseCase);
  });

  test('Initial state should be Initial', () {
    expect(bloc.state, equals(UsersBlocInitial()));
  });

  group('GetBelovedOnesListEvent', () {
    Account ownedAccount1 = const Account(name: 'Account One');
    Account ownedAccount2 = const Account(name: 'Account Two');

    final ownedAccountList = [ownedAccount1, ownedAccount2];

    blocTest<UsersBlocBloc, UsersBlocState>(
      'should emit UsersBlocSuccess state when OwnedAccounts list retrieval is successful',
      build: () {
        when(mockGetBelovedOnesListUseCase.call(const NoParams()))
            .thenAnswer((_) async => Right(ownedAccountList));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOwnedAccountsListEvent()),
      expect: () => [
        UsersBlocLoading(),
        UsersBlocSuccess(ownedAccounstList: ownedAccountList),
      ],
    );
    blocTest<UsersBlocBloc, UsersBlocState>(
      'should emit UsersBlocError state when OwnedAccounts list retrieval is unsuccessful',
      build: () {
        when(mockGetBelovedOnesListUseCase.call(const NoParams())).thenAnswer(
            (_) async => const Left(
                ServerFailure(message: 'Failed to fetch Owned Accounts List')));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOwnedAccountsListEvent()),
      expect: () => [
        UsersBlocLoading(),
        UsersBlocError(),
      ],
    );
  });
}
