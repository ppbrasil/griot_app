import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';

class MemoriesListPage extends StatefulWidget {
  const MemoriesListPage({super.key});

  @override
  State<MemoriesListPage> createState() => _MemoriesListPageState();
}

class _MemoriesListPageState extends State<MemoriesListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemoriesBlocBloc>(context).add(GetMemoriesListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Memories List'),
      ),
      body: BlocBuilder<MemoriesBlocBloc, MemoriesBlocState>(
        builder: (context, state) {
          if (state is MemoriesGetListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MemoriesGetListSuccess) {
            final memories = state.memories;
            // Build your list view using the `memories` data
            return ListView.builder(
              itemCount: memories.length,
              itemBuilder: (context, index) {
                final memory = memories[index];
                return ListTile(
                  title: Text(memory.title),
                  // Customize the list tile as per your requirements
                );
              },
            );
          } else if (state is MemoriesGetListFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
