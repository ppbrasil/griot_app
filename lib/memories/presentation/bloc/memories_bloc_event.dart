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

class CreateMemoryEvent extends MemoriesBlocEvent {
  final String? title;

  const CreateMemoryEvent({required this.title});

  @override
  List<Object> get props => [];
}

class GetMemoriesListEvent extends MemoriesBlocEvent {}
