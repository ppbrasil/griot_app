import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_bloc_event.dart';
part 'navigation_bloc_state.dart';

class NavigationBloc extends Bloc<NavigationBlocEvent, NavigationBlocState> {
  NavigationBloc() : super(const NavigationDashboardState()) {
    on<DashboardClickedEvent>((event, emit) {
      emit(const NavigationDashboardState());
    });

    on<MemoriesListClickedEvent>((event, emit) {
      emit(const NavigationMemoriesListState());
    });

    on<MemoriesCreationClickedEvent>((event, emit) {
      emit(const NavigationMemoriesCreationState());
    });

    on<BelovedOnesListClickedEvent>((event, emit) {
      emit(const NavigationBelovedOnesListState());
    });

    on<ProfileDetailsClickedEvent>((event, emit) {
      emit(const NavigationProfileDetailsState());
    });
  }
}
