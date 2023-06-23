part of 'memories_bloc_bloc.dart';

abstract class MemoriesBlocEvent extends Equatable {
  const MemoriesBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMemoryDetailsEvent extends MemoriesBlocEvent {
  final int memoryId;

  const GetMemoryDetailsEvent({required this.memoryId});

  @override
  List<Object> get props => [memoryId];
}

class GetMemoriesListEvent extends MemoriesBlocEvent {}
