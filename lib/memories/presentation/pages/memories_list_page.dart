import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';
import 'package:griot_app/core/presentation/widgets/griot_app_bar.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:griot_app/griot_app.dart';
import 'package:griot_app/memories/presentation/widgets/griot_action_button.dart';
import 'package:griot_app/memories/presentation/widgets/griot_memories_list_tile.dart';

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
    return BasePage(
      child: Scaffold(
        appBar: const GriotAppBar(
          automaticallyImplyLeading: false,
          title: 'Memories List',
        ),
        body: BlocBuilder<MemoriesBlocBloc, MemoriesBlocState>(
          builder: (context, state) {
            if (state is MemoriesGetListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MemoriesGetListSuccess) {
              final memories = state.memories;
              if (memories.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memory = memories[index];
                      return GriotMemoryListTile(
                        memory: memory,
                      );
                    },
                  ),
                );
              } else {
                return Padding(
                  padding:
                      const EdgeInsets.all(45.0), // Add padding to the Column
                  child: Center(
                    // Align Column in the center of the screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Align Column items in the center of the column
                      children: [
                        const Spacer(flex: 2), // Add space before first Text
                        Text(
                          'Looks like you didn\'t save a Memory yet.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(flex: 4), // Add space before first Text
                        Text(
                          'Here will be your Memories List.\nWhat about start creating it now?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(flex: 4), // Add space before first Text
                        GriotActionButton(
                          label: 'Create my First Memory',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/memories_manipulation_page',
                              arguments: null,
                            );
                          },
                        ),
                        const Spacer(flex: 10), // Add space after the Button
                      ],
                    ),
                  ),
                );
              }
            } else if (state is MemoriesGetListFailure) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
