part of 'beloved_ones_bloc_bloc.dart';

abstract class BelovedOnesBlocEvent extends Equatable {
  const BelovedOnesBlocEvent();

  @override
  List<Object> get props => [];
}

class GetBelovedOnesListEvent extends BelovedOnesBlocEvent {}
