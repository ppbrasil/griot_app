import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  Uri videoUri = Uri.parse(video.file);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GriotVideoTile(
                      videoPlayerController:
                          VideoPlayerController.networkUrl(videoUri),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class GriotVideoTile extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const GriotVideoTile({super.key, required this.videoPlayerController});

  @override
  State<GriotVideoTile> createState() => _GriotVideoTileState();
}

class _GriotVideoTileState extends State<GriotVideoTile> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      autoPlay: false,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
            child: Text(errorMessage,
                style: const TextStyle(color: Colors.white)));
      },
    );
    // Set preferred orientation to landscape if video is horizontal
    final videoValue = widget.videoPlayerController.value;
    if (videoValue.size.width > videoValue.size.height) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final videoAspectRatio = widget.videoPlayerController.value.aspectRatio;
    final isHorizontalVideo =
        (widget.videoPlayerController.value.size.aspectRatio > 1);

    return WillPopScope(
      onWillPop: () async {
        if (isHorizontalVideo) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }
        return true; // Allow back navigation
      },
      child: AspectRatio(
        aspectRatio: 316 / 150, // Replace with your desired aspect ratio
        child: Container(
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  8.0), // Adjust the border radius as needed
              child: FittedBox(
                fit: BoxFit.cover,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
