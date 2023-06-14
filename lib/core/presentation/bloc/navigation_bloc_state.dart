part of 'navigation_bloc_bloc.dart';

abstract class NavigationBlocState extends Equatable {
  final int index;

  const NavigationBlocState(this.index);

  @override
  List<Object> get props => [index];
}

class NavigationBlocInitial extends NavigationBlocState {
  const NavigationBlocInitial() : super(0);
}

class NavigationDashboardState extends NavigationBlocState {
  const NavigationDashboardState() : super(0);
}

class NavigationMemoriesListState extends NavigationBlocState {
  const NavigationMemoriesListState() : super(1);
}

class NavigationMemoriesCreationState extends NavigationBlocState {
  const NavigationMemoriesCreationState() : super(2);
}

class NavigationBelovedOnesListState extends NavigationBlocState {
  const NavigationBelovedOnesListState() : super(3);
}

class NavigationProfileDetailsState extends NavigationBlocState {
  const NavigationProfileDetailsState() : super(4);
}
