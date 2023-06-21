import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:griot_app/accounts/domain/entities/beloved_one.dart';
import 'package:griot_app/accounts/domain/use_cases/get_beloved_ones_list_use_case.dart'
    as getBelovedOnesListUseCase;
import 'package:griot_app/core/data/main_account_id_provider.dart';

part 'beloved_ones_bloc_event.dart';
part 'beloved_ones_bloc_state.dart';

class BelovedOnesBlocBloc
    extends Bloc<BelovedOnesBlocEvent, BelovedOnesBlocState> {
  final getBelovedOnesListUseCase.GetBelovedOnesListUseCase getBelovedOnesList;
  final MainAccountIdProvider mainsAccountIdProvider;

  BelovedOnesBlocBloc({
    required this.mainsAccountIdProvider,
    required this.getBelovedOnesList,
  }) : super(BelovedOnesBlocInitial()) {
    on<GetBelovedOnesListEvent>((event, emit) async {
      emit(BelovedOnesBlocLoading());
      int accountId = await mainsAccountIdProvider.getMainAccountId();
      final belovedListEither = await getBelovedOnesList(
          getBelovedOnesListUseCase.Params(accountId: accountId));
      belovedListEither.fold(
        (failure) => emit(BelovedOnesBlocError()),
        (getBelovedOnesList) =>
            emit(BelovedOnesBlocSuccess(belovedOnesList: getBelovedOnesList)),
      );
    });
  }
}
