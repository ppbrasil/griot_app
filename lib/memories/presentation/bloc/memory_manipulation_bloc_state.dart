part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocState extends Equatable {
  const MemoryManipulationBlocState();

  @override
  List<Object> get props => [];
}

class MemoryCreationBlocInitial extends MemoryManipulationBlocState {}

class MemoryLoading extends MemoryManipulationBlocState {}

class MemoryCreationBlocFailure extends MemoryManipulationBlocState {}

class VideoUploadingState extends MemoryManipulationBlocState {}

class MemorySuccessState extends MemoryManipulationBlocState {
  final Memory memory;

  const MemorySuccessState({required this.memory});

  @override
  List<Object> get props => [memory];
}

class MemoryFailureState extends MemoryManipulationBlocState {}
