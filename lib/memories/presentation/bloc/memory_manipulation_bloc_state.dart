part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocState extends Equatable {
  const MemoryManipulationBlocState();

  @override
  List<Object?> get props => [];
}

class MemoryCreationBlocInitial extends MemoryManipulationBlocState {}

class MemoryLoading extends MemoryManipulationBlocState {}

class MemoryCreationBlocFailure extends MemoryManipulationBlocState {}

class VideoUploadingState extends MemoryManipulationBlocState {}

class MemoryManipulationSuccessState extends MemoryManipulationBlocState {
  final Memory memory;

  const MemoryManipulationSuccessState({required this.memory});

  @override
  List<Object> get props => [memory];
}

class MemoryManipulationFailureState extends MemoryManipulationBlocState {
  final String? titleErrorMesssage;
  final String? videoAddingErrorMesssage;
  final String? savingErrorMesssage;

  const MemoryManipulationFailureState({
    required this.titleErrorMesssage,
    required this.videoAddingErrorMesssage,
    required this.savingErrorMesssage,
  });
  @override
  List<Object?> get props => [
        titleErrorMesssage,
        videoAddingErrorMesssage,
        savingErrorMesssage,
      ];
}

class MemoryRetrievalFailureState extends MemoryManipulationBlocState {}
