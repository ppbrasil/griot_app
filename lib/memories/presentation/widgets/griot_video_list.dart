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
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.memory!.videos != null
                  ? state.memory!.videos!.length
                  : 0,
              itemBuilder: (context, index) {
                final video = state.memory!.videos![index];
                return GriotTile(
                  videoPlayerController:
                      VideoPlayerController.network(video.file),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class GriotTile extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const GriotTile({super.key, required this.videoPlayerController});

  @override
  State<GriotTile> createState() => _GriotTileState();
}

class _GriotTileState extends State<GriotTile> {
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
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: videoAspectRatio,
              child: Chewie(
                controller: _chewieController,
              ),
            )),
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
