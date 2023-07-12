import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
import 'package:griot_app/memories/presentation/bloc/griot_video_player_bloc_bloc.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
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
                    builder: (context) {
                      return BlocProvider(
                        create: (context) =>
                            GriotVideoPlayerBlocBloc(videoUrl: video.file),
                        child: GriotVideoPlayer(video: video),
                      );
                    },
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
  late GriotVideoPlayerBlocBloc _bloc;
  late StreamSubscription<NativeDeviceOrientation> _orientationSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<GriotVideoPlayerBlocBloc>(context);

    _orientationSubscription = NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      _bloc.add(GriotVideoPlayerBlocOrientationChangedEvent(
        orientation: event,
        isFullScreen: _bloc.videoService.chewieController.isFullScreen,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _bloc.dispose();
        _orientationSubscription.cancel();
        return true;
      },
      child: BlocBuilder<GriotVideoPlayerBlocBloc, GriotVideoPlayerBlocState>(
        builder: (context, state) {
          if (state is GriotVideoPlayerBlocInitialState) {
            context
                .read<GriotVideoPlayerBlocBloc>()
                .add(const GriotVideoPlayerBlocInitializedEvent());
            return const Text('Loading');
          } else if (state is GriotVideoPlayerBlocLoadedState) {
            return Scaffold(
              appBar: const VideoAppBar(),
              backgroundColor: Colors.black,
              body: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Chewie(
                    controller: state.chewieController,
                  ),
                ),
              ),
            );
          } else if (state is GriotVideoPlayerBlocLoadingState) {
            return const Text('Loading');
          } else {
            return const Text('Failed');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _orientationSubscription.cancel();
    super.dispose();
  }
}

class VideoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VideoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
