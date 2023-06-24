import 'package:dartz/dartz.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/core/error/failures.dart';
import 'package:griot_app/core/data/main_account_id_provider.dart';

import 'package:griot_app/accounts/domain/use_cases/get_beloved_ones_list_use_case.dart';
import 'package:griot_app/accounts/presentation/bloc/beloved_ones_bloc_bloc.dart';

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';

import 'beloved_ones_bloc_bloc_test.mocks.dart';

@GenerateMocks([GetBelovedOnesListUseCase, MainAccountIdProvider])
void main() {
  late BelovedOnesBlocBloc bloc;
  late MockGetBelovedOnesListUseCase mockGetBelovedOnesListUseCase;
  late MockMainAccountIdProvider mockMainAccountIdProvider;

  setUp(() {
    mockGetBelovedOnesListUseCase = MockGetBelovedOnesListUseCase();
    mockMainAccountIdProvider = MockMainAccountIdProvider();
    bloc = BelovedOnesBlocBloc(
        mainAccountIdProvider: mockMainAccountIdProvider,
        getBelovedOnesList: mockGetBelovedOnesListUseCase);
  });

  test('Initial state should be Empty', () {
    expect(bloc.state, equals(BelovedOnesBlocInitial()));
  });

  group('GetMemoriesListEvent', () {
    const int tAccountId = 1;
    BelovedOne belovedOne1 = const BelovedOne();
    BelovedOne belovedOne2 = const BelovedOne();

    final tBelovedOnesList = [belovedOne1, belovedOne2];

    blocTest<BelovedOnesBlocBloc, BelovedOnesBlocState>(
      'should emit BelovedOnesBlocSuccess state when BelovedOnes list retrieval is successful',
      build: () {
        when(mockGetBelovedOnesListUseCase
                .call(const Params(accountId: tAccountId)))
            .thenAnswer((_) async => Right(tBelovedOnesList));
        when(mockMainAccountIdProvider.getMainAccountId())
            .thenAnswer((_) async => (1));
        return bloc;
      },
      act: (bloc) => bloc.add(GetBelovedOnesListEvent()),
      expect: () => [
        BelovedOnesBlocLoading(),
        BelovedOnesBlocSuccess(belovedOnesList: tBelovedOnesList),
      ],
    );
    blocTest<BelovedOnesBlocBloc, BelovedOnesBlocState>(
      'should emit BelovedOnesBlocError state when BelovedOnes list retrieval is unsuccessful',
      build: () {
        when(mockGetBelovedOnesListUseCase
                .call(const Params(accountId: tAccountId)))
            .thenAnswer((_) async => const Left(
                ServerFailure(message: 'Failed to fetch Beloved Ones List')));
        when(mockMainAccountIdProvider.getMainAccountId())
            .thenAnswer((_) async => (1));
        return bloc;
      },
      act: (bloc) => bloc.add(GetBelovedOnesListEvent()),
      expect: () => [
        BelovedOnesBlocLoading(),
        BelovedOnesBlocError(),
      ],
    );
  });
}
