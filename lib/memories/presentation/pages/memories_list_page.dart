import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:griot_app/griot_app.dart';

class MemoriesListPage extends StatefulWidget {
  const MemoriesListPage({super.key});

  @override
  State<MemoriesListPage> createState() => _MemoriesListPageState();
}

class _MemoriesListPageState extends State<MemoriesListPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemoriesBlocBloc>(context).add(GetMemoriesListEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Refresh your Bloc state or perform any necessary actions here when the user comes back to this screen
    BlocProvider.of<MemoriesBlocBloc>(context).add(
        GetMemoriesListEvent()); // assuming you have a RefreshEvent in your Bloc
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/memories_details_page',
                        arguments: memory,
                      );
                    },
                    child: Container(
                      height: 146.0, // Set the height of the container
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [
                            0.0,
                            1.24
                          ], // Stops make the gradient to end before the end of the box
                          colors: [
                            Color(0xFF92A3FD),
                            Color(0xFF9DCEFF)
                          ], // You can adjust the colors
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(149, 173, 254, 0.3),
                            blurRadius: 22,
                            offset: Offset(0, 10), // Position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              color: Colors.white,
                              // Placeholder color
                            ),
                          ),
                          Expanded(
                            child: Text(
                              memory.title,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500, // Use 500 weight
                                fontSize: 14.0, // Font size is 14
                                height: 21 /
                                    14, // Line height (leading) is 21, so height is 21 / font size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
