import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:griot_app/core/services/griot_video_services.dart';

import 'package:equatable/equatable.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

part 'griot_video_player_bloc_event.dart';
part 'griot_video_player_bloc_state.dart';

class GriotVideoPlayerBlocBloc
    extends Bloc<GriotVideoPlayerBlocEvent, GriotVideoPlayerBlocState> {
  late GriotVideoService videoService;

  GriotVideoPlayerBlocBloc({
    required String videoUrl,
  }) : super(GriotVideoPlayerBlocInitialState()) {
    //
    // GriotVideoPlayerBlocInitializedEvent
    on<GriotVideoPlayerBlocInitializedEvent>((event, emit) async {
      // emit Loading state for better UX

      emit(GriotVideoPlayerBlocLoadingState());
      try {
        videoService = GriotVideoService(videoUrl: videoUrl);
        await videoService.initialize();
        emit(GriotVideoPlayerBlocLoadedState(
            chewieController: videoService.chewieController));
      } catch (error) {
        emit(GriotVideoPlayerFailureState());
      }
    });

    on<GriotVideoPlayerBlocOrientationChangedEvent>((event, emit) async {
      final bool isPortrait =
          (event.orientation == NativeDeviceOrientation.portraitUp ||
              event.orientation == NativeDeviceOrientation.portraitDown);
      final bool isLandscape =
          (event.orientation == NativeDeviceOrientation.landscapeLeft ||
              event.orientation == NativeDeviceOrientation.landscapeRight);

      if (isPortrait && event.isFullScreen) {
        videoService.chewieController.exitFullScreen();
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      } else if (isLandscape && !event.isFullScreen) {
        videoService.chewieController.enterFullScreen();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      }
    });
  }

  void dispose() {
    videoService.dispose();
  }
}
