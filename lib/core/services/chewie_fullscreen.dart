import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:griot_app/core/services/video_streaming_service.dart';

class ChewiePlayer extends StatelessWidget {
  final ChewieService? chewieService;

  const ChewiePlayer({super.key, required this.chewieService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: chewieService!.chewieController,
      ),
    );
  }
}
