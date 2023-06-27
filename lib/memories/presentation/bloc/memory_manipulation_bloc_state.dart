part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocState extends Equatable {
  final Memory? memory;
  const MemoryManipulationBlocState({required this.memory});

  @override
  List<Object?> get props => [memory];
}

class MemoryCreationBlocInitial extends MemoryManipulationBlocState {
  const MemoryCreationBlocInitial({required super.memory});
}

class MemoryLoading extends MemoryManipulationBlocState {
  const MemoryLoading({required super.memory});
}

class VideoUploadingState extends MemoryManipulationBlocState {
  const VideoUploadingState({required super.memory});
}

class MemoryManipulationSuccessState extends MemoryManipulationBlocState {
  const MemoryManipulationSuccessState({required super.memory});
}

class MemoryCreationBlocFailure extends MemoryManipulationBlocState {
  const MemoryCreationBlocFailure({required super.memory});
}

class MemoryManipulationFailureState extends MemoryManipulationBlocState {
  final String? titleErrorMesssage;
  final String? videoAddingErrorMesssage;
  final String? savingErrorMesssage;

  const MemoryManipulationFailureState({
    required super.memory,
    required this.titleErrorMesssage,
    required this.videoAddingErrorMesssage,
    required this.savingErrorMesssage,
  });
  @override
  List<Object?> get props => [
        memory,
        titleErrorMesssage,
        videoAddingErrorMesssage,
        savingErrorMesssage,
      ];
}

class MemoryRetrievalFailureState extends MemoryManipulationBlocState {
  const MemoryRetrievalFailureState({required super.memory});
}
