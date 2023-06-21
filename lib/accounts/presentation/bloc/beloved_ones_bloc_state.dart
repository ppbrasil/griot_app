part of 'beloved_ones_bloc_bloc.dart';

abstract class BelovedOnesBlocState extends Equatable {
  const BelovedOnesBlocState();

  @override
  List<Object> get props => [];
}

class BelovedOnesBlocInitial extends BelovedOnesBlocState {}

class BelovedOnesBlocLoading extends BelovedOnesBlocState {}

class BelovedOnesBlocSuccess extends BelovedOnesBlocState {
  final List<BelovedOne> belovedOnesList;

  const BelovedOnesBlocSuccess({required this.belovedOnesList});

  @override
  List<Object> get props => [belovedOnesList];
}

class BelovedOnesBlocError extends BelovedOnesBlocState {}
