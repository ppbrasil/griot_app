import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/domain/entities/video.dart';
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
                return GriotTile(video: video);
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

class GriotTile extends StatelessWidget {
  final Video video;

  const GriotTile({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(video.thumbnail ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgWy3DLSoDNZxaoOiVo3G9I7-fXtRAztlpB8YtYejl&s'),
      ),
    );
  }
}
