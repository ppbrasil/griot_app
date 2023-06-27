import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class MemoryDetailsPage extends StatefulWidget {
  final Memory memory;

  const MemoryDetailsPage({Key? key, required this.memory}) : super(key: key);

  @override
  _MemoryDetailsPageState createState() => _MemoryDetailsPageState();
}

class _MemoryDetailsPageState extends State<MemoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MemoryManipulationBlocBloc>(),
      child:
          BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
        builder: (context, state) {
          if (state is MemoryCreationBlocInitial) {
            BlocProvider.of<MemoryManipulationBlocBloc>(context)
                .add(GetMemoryDetailsEvent(memoryId: widget.memory.id!));
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is MemoryLoading) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is MemoryManipulationSuccessState) {
            final memory = state.memory;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Memory Details'),
              ),
              body: Column(
                children: [
                  Text(
                    memory!.title ?? 'New Memory',
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  state.memory!.videos != null
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state.memory!.videos!.length,
                            itemBuilder: (context, index) {
                              final video = state.memory!.videos![index];
                              return ListTile(
                                title: Text(
                                  video.file,
                                  style: const TextStyle(fontSize: 8),
                                ),
                                // Add more widgets or customize the list item as needed
                              );
                            },
                          ),
                        )
                      : const Expanded(
                          child: Center(
                            child: Text('No videos available'),
                          ),
                        ) // Display a message if the videos list is null,
                ],
              ),
            );
          } else if (state is MemoryManipulationFailureState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Memory Details'),
              ),
              body: const Center(
                child: Text('failure'),
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
