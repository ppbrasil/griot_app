part of 'memory_creation_bloc_bloc.dart';

abstract class MemoryCreationBlocState extends Equatable {
  const MemoryCreationBlocState();

  @override
  List<Object> get props => [];
}

class MemoryCreationBlocInitial extends MemoryCreationBlocState {}

class MemoryCreatingState extends MemoryCreationBlocState {}

class VideoUploadingState extends MemoryCreationBlocState {}

class MemoryCreateSuccessState extends MemoryCreationBlocState {}

class MemoryCreateErrorState extends MemoryCreationBlocState {}

class VideoPickingState extends MemoryCreationBlocState {}

class VideoPickedState extends MemoryCreationBlocState {}
