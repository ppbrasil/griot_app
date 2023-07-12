part of 'griot_video_player_bloc_bloc.dart';

abstract class GriotVideoPlayerBlocEvent extends Equatable {
  const GriotVideoPlayerBlocEvent();

  @override
  List<Object> get props => [];
}

class GriotVideoPlayerBlocInitializedEvent extends GriotVideoPlayerBlocEvent {
  /// This event would be triggered when the Video and Chewie players are initialized,
  /// resulting a video player rendered in screen

  const GriotVideoPlayerBlocInitializedEvent();

  @override
  List<Object> get props => [];
}

class GriotVideoPlayerBlocOrientationChangedEvent
    extends GriotVideoPlayerBlocEvent {
  final NativeDeviceOrientation orientation;
  final bool isFullScreen;

  /// This event would be triggered when the Video and Chewie players are initialized,
  /// resulting a video player rendered in screen

  const GriotVideoPlayerBlocOrientationChangedEvent(
      {required this.orientation, required this.isFullScreen});

  @override
  List<Object> get props => [orientation, isFullScreen];
}
