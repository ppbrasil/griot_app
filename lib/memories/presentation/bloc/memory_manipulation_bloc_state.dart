part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocState extends Equatable {
  const MemoryManipulationBlocState();

  @override
  List<Object> get props => [];
}

class MemoryCreationBlocInitial extends MemoryManipulationBlocState {}

class MemoryCreationBlocLoading extends MemoryManipulationBlocState {}

class MemoryCreationBlocFailure extends MemoryManipulationBlocState {}

class VideoUploadingState extends MemoryManipulationBlocState {}

class MemoryUpdateSuccessState extends MemoryManipulationBlocState {
  final Memory memory;

  const MemoryUpdateSuccessState({required this.memory});

  @override
  List<Object> get props => [memory];
}

class MemoryUpdateErrorState extends MemoryManipulationBlocState {}
