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

  const MemoryTitleChangedEvent({
    required this.title,
  });

  @override
  List<Object?> get props => [title];
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

class GetMemoryDetailsEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when a details page is rendered,
  /// resulting in a memory being retrieved from the data provider
  final int memoryId;

  const GetMemoryDetailsEvent({required this.memoryId});

  @override
  List<Object> get props => [memoryId];
}

class CommitMemoryEvent extends MemoryManipulationBlocEvent {
  /// This event would be triggered when a update page is commited,
  /// it should take a draft memory and return an updated memory persisted in the server
  final Memory memory;

  const CommitMemoryEvent({required this.memory});

  @override
  List<Object> get props => [memory];
}
