part of 'memories_bloc_bloc.dart';

abstract class MemoriesBlocState extends Equatable {
  const MemoriesBlocState();

  @override
  List<Object> get props => [];
}

class MemoryInitial extends MemoriesBlocState {}

class MemoriesInitial extends MemoriesBlocState {}

class MemoryGetDetailsLoading extends MemoriesBlocState {}

class MemoryGetDetailsSuccess extends MemoriesBlocState {
  final Memory memory;

  MemoryGetDetailsSuccess({required this.memory});

  @override
  List<Object> get props => [memory];
}

class MemoryGetDetailsFailure extends MemoriesBlocState {
  final String message;

  MemoryGetDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class MemoryCreationLoading extends MemoriesBlocState {}

class MemoryCreationSuccess extends MemoriesBlocState {
  final Memory memory;

  MemoryCreationSuccess({required this.memory});

  @override
  List<Object> get props => [memory];
}

class MemoryCreationFailure extends MemoriesBlocState {
  final String message;

  MemoryCreationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class MemoriesGetListLoading extends MemoriesBlocState {}

class MemoriesGetListSuccess extends MemoriesBlocState {
  final List<Memory> memories;

  const MemoriesGetListSuccess({required this.memories});

  @override
  List<Object> get props => [memories];
}

class MemoriesGetListFailure extends MemoriesBlocState {
  final String message;

  const MemoriesGetListFailure({required this.message});

  @override
  List<Object> get props => [message];
}
