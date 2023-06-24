import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

abstract class VideoStreamingService {
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  double get currentPlaybackPosition;
  String get videoUrl;
  bool get autoPlay;
  bool get looping;
}

class ChewieService implements VideoStreamingService {
  ChewieController chewieController;

  ChewieService({required this.chewieController});

  @override
  Future<void> play() async {
    chewieController.play();
  }

  @override
  Future<void> pause() async {
    chewieController.pause();
  }

  @override
  Future<void> stop() async {
    chewieController.pause();
    chewieController.seekTo(Duration.zero);
  }

  @override
  double get currentPlaybackPosition {
    return chewieController.videoPlayerController.value.position.inSeconds
        .toDouble();
  }

  @override
  String get videoUrl {
    return chewieController.videoPlayerController.dataSource;
  }

  @override
  bool get autoPlay {
    return chewieController.autoPlay;
  }

  @override
  bool get looping {
    return chewieController.looping;
  }
}

class ChewieServiceFactory {
  ChewieService createChewieService(
      {required String url, bool autoPlay = false, bool looping = false}) {
    final videoPlayerController = VideoPlayerController.network(url);
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: autoPlay,
      looping: looping,
      fullScreenByDefault: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    return ChewieService(chewieController: chewieController);
  }
}
