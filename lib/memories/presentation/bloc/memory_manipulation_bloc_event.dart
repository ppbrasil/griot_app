part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocEvent extends Equatable {
  const MemoryManipulationBlocEvent();

  @override
  List<Object> get props => [];
}

class CreateMemoryEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user clickes to create a new Memory,
  /// resulting in a new memory being created and the user being redirected to the MemoryCreationPage
  final String? title;

  const CreateMemoryEvent({required this.title});

  @override
  List<Object> get props => [];
}

class AddVideoClickedEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user wants to access the device's library to select media files,
  /// resulting in the selected videos being upload to the API.
  const AddVideoClickedEvent();

  @override
  List<Object> get props => [];
}

class TitleEditedEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user leaves (lose focus) of the Title field,
  /// resulting in the new title being preserved in the new memory entity.
  const TitleEditedEvent();

  @override
  List<Object> get props => [];
}
