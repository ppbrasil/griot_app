part of 'navigation_bloc_bloc.dart';

abstract class NavigationBlocEvent extends Equatable {
  const NavigationBlocEvent();

  @override
  List<Object> get props => [];
}

class DashboardClickedEvent extends NavigationBlocEvent {}

class MemoriesListClickedEvent extends NavigationBlocEvent {}

class MemoriesCreationClickedEvent extends NavigationBlocEvent {}

class BelovedOnesListClickedEvent extends NavigationBlocEvent {}

class ProfileDetailsClickedEvent extends NavigationBlocEvent {}
