import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/account.dart';
import 'package:griot_app/user/domain/use_cases/get_user_owned_accounts_list_usecase.dart'
    as getOwnedAccountsUseCase;

part 'users_bloc_event.dart';
part 'users_bloc_state.dart';

class UsersBlocBloc extends Bloc<UsersBlocEvent, UsersBlocState> {
  final getOwnedAccountsUseCase.GetOwnedAccountsListUseCase getOwnedAccounts;

  UsersBlocBloc({required this.getOwnedAccounts}) : super(UsersBlocInitial()) {
    on<GetBelovedOnesListEvent>((event, emit) async {
      emit(UsersBlocLoading());

      final ownedAccountsListEither =
          await getOwnedAccounts(const getOwnedAccountsUseCase.NoParams());
      ownedAccountsListEither.fold(
          (failure) => emit(UsersBlocError()),
          (getBelovedOnesList) =>
              emit(UsersBlocSuccess(ownedAccounstList: getBelovedOnesList)));
    });
  }
}
