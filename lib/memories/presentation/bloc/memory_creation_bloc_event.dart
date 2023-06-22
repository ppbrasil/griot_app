part of 'memory_creation_bloc_bloc.dart';

abstract class MemoryCreationBlocEvent extends Equatable {
  const MemoryCreationBlocEvent();

  @override
  List<Object> get props => [];
}

class TitleEditedEvent extends MemoryCreationBlocEvent {
  /// This event would be triggered when the user leaves (lose focus) of the Title field,
  /// resulting in the new title being preserved in the new memory entity.
  const TitleEditedEvent();

  @override
  List<Object> get props => [];
}

class SelectVideoClickedEvent extends MemoryCreationBlocEvent {
  /// This event would be triggered when the user wants to access the device's library to select media files,
  /// resulting in the video picker kicking in to display the current media files in the livrary.
  const SelectVideoClickedEvent();

  @override
  List<Object> get props => [];
}

class SubmitVideoClickedEvent extends MemoryCreationBlocEvent {
  /// This event would be triggered when the user is done with memory creation and wants to submit it,
  /// resulting in the video upload and memory creation on your backend.
  const SubmitVideoClickedEvent();

  @override
  List<Object> get props => [];
}
