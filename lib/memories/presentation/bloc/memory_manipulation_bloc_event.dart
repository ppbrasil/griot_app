part of 'memory_manipulation_bloc_bloc.dart';

abstract class MemoryManipulationBlocEvent extends Equatable {
  const MemoryManipulationBlocEvent();

  @override
  List<Object?> get props => [];
}

class CreateNewMemoryClickedEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user clickes to create a new Memory,
  /// resulting in a new memory being created and the user being redirected to the MemoryCreationPage

  const CreateNewMemoryClickedEvent();

  @override
  List<Object> get props => [];
}

class MemoryTitleChangedEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user changesthe title of a Memory calling for a validation check.
  /// If successful blakcs out the error message if fails sets a new error message.
  final String title;
  final String? videoAddingErrorMesssage;
  final String? savingErrorMesssage;
  final Memory memory;

  const MemoryTitleChangedEvent({
    required this.title,
    required this.videoAddingErrorMesssage,
    required this.savingErrorMesssage,
    required this.memory,
  });

  @override
  List<Object?> get props =>
      [title, videoAddingErrorMesssage, savingErrorMesssage, memory];
}

class GetMemoryDetailsEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when a details page is rendered,
  /// resulting in a memory being retrieved from the data provider
  final int memoryId;

  const GetMemoryDetailsEvent({required this.memoryId});

  @override
  List<Object> get props => [memoryId];
}

class AddVideoClickedEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when the user wants to access the device's library to select media files,
  /// resulting in the selected videos being upload to the API.
  final Memory memory;

  const AddVideoClickedEvent({
    required this.memory,
  });

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
