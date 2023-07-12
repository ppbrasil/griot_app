part of 'griot_video_player_bloc_bloc.dart';

abstract class GriotVideoPlayerBlocState extends Equatable {
  const GriotVideoPlayerBlocState();

  @override
  List<Object> get props => [];
}

class GriotVideoPlayerBlocInitialState extends GriotVideoPlayerBlocState {}

class GriotVideoPlayerBlocLoadingState extends GriotVideoPlayerBlocState {}

class GriotVideoPlayerBlocLoadedState extends GriotVideoPlayerBlocState {
  final ChewieController chewieController;

  const GriotVideoPlayerBlocLoadedState({required this.chewieController});
}

class GriotVideoPlayerFailureState extends GriotVideoPlayerBlocState {}
