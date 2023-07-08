import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class GriotVideoList extends StatefulWidget {
  const GriotVideoList({super.key});

  @override
  State<GriotVideoList> createState() => _GriotVideoListState();
}

class _GriotVideoListState extends State<GriotVideoList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
              builder: (context, state) {
        if (state is MemoryManipulationSuccessState ||
            state is MemoryManipulationFailureState) {
          return Column(
            children: List<Widget>.generate(
                state.memory!.videos != null ? state.memory!.videos!.length : 0,
                (index) {
              final video = state.memory!.videos![index];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GriotVideoPlayer(video: video),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center, // to center the play icon
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AspectRatio(
                        aspectRatio: 316 / 150,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded edges
                          child: FittedBox(
                            fit: BoxFit
                                .cover, // This BoxFit will cover the box with the image, potentially cropping it, while maintaining the image proportions
                            child: video.thumbnail != null
                                ? Image.network(
                                    video.thumbnail!) // remote thumbnail
                                : video.thumbnailData != null
                                    ? Image.memory(
                                        video.thumbnailData!) // local thumbnail
                                    : Container(), // Some fallback in case of no thumbnail. Adjust this according to your needs.
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_fill, // Play icon
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ],
                ),
              );
            }),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class GriotVideoPlayer extends StatefulWidget {
  final Video video;

  const GriotVideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  State<GriotVideoPlayer> createState() => _GriotVideoPlayerState();
}

class _GriotVideoPlayerState extends State<GriotVideoPlayer> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.file),
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      autoPlay: true,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
            child: Text(errorMessage,
                style: const TextStyle(color: Colors.white)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
