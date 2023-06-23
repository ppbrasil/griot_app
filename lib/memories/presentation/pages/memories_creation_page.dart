import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class MemoriesCreationPage extends StatefulWidget {
  const MemoriesCreationPage({super.key});

  @override
  State<MemoriesCreationPage> createState() => _MemoriesCreationPageState();
}

class _MemoriesCreationPageState extends State<MemoriesCreationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
        builder: (context, state) {
      if (state is MemoryUpdateSuccessState) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Memory creation'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<MemoryManipulationBlocBloc>(context)
                    .add(AddVideoClickedEvent(memory: state.memory));
              },
              child: const Text('Add Videos'),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
