import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/core/services/chewie_fullscreen.dart';
import 'package:griot_app/core/services/video_streaming_service.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class MemoriesCreationPage extends StatefulWidget {
  const MemoriesCreationPage({super.key});

  @override
  State<MemoriesCreationPage> createState() => _MemoriesCreationPageState();
}

class _MemoriesCreationPageState extends State<MemoriesCreationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MemoryManipulationBlocBloc>(),
      child:
          BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
        builder: (context, state) {
          if (state is MemoryCreationBlocInitial) {
            BlocProvider.of<MemoryManipulationBlocBloc>(context)
                .add(const CreateMemoryEvent(title: '', videos: []));
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is MemorySuccessState) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Memory creation'),
              ),
              body: Column(
                children: [
                  Text(
                    state.memory.videos == null
                        ? 'NUll'
                        : state.memory.videos!.isEmpty
                            ? 'Empty'
                            : 'Many',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  state.memory.videos != null
                      ? Expanded(
                          child: ListView(
                            children: List.generate(state.memory.videos!.length,
                                (index) {
                              final video = state.memory.videos![index];
                              return videoThumbnail(
                                context,
                                thumbnailUrl: video.thumbnail!,
                                videoUrl: video.file,
                              );
                            }),
                          ),
                        )
                      : const Center(
                          child: Text('No videos available'),
                        ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<MemoryManipulationBlocBloc>(context)
                          .add(AddVideoClickedEvent(memory: state.memory));
                    },
                    child: state.memory.videos != null
                        ? const Text('Add More Videos')
                        : const Text('Add Some Video'),
                  ),
                ],
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

Widget videoThumbnail(BuildContext context,
    {required String thumbnailUrl, required String videoUrl}) {
  final chewieServiceFactory = ChewieServiceFactory();
  final chewieService = chewieServiceFactory.createChewieService(
    url: videoUrl,
    autoPlay: true,
    looping: false,
  );

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) {
          return ChewiePlayer(chewieService: chewieService);
        }),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(45.0),
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    ),
  );
}
