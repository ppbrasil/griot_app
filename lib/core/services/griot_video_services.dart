import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class GriotVideoService {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  GriotVideoService({required String videoUrl}) {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  }

  Future<void> initialize() async {
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      fullScreenByDefault: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      autoPlay: true,
      autoInitialize: true,
    );
  }

  ChewieController get chewieController => _chewieController;

  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
