import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/accounts/presentation/pages/beloved_ones_list_page.dart';
import 'package:griot_app/core/presentation/bloc/navigation_bloc_bloc.dart';
import 'package:griot_app/core/presentation/pages/dashboard.dart';
import 'package:griot_app/core/presentation/widgets/griot_bottom_navigation_bar.dart';
import 'package:griot_app/memories/presentation/pages/memories_list_page.dart';
import 'package:griot_app/memories/presentation/pages/memories_manipulation_page.dart';
import 'package:griot_app/profile/presentation/pages/profile_details_page.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const Dashboard(),
    const MemoriesListPage(),
    const MemoryManipulationPage(
      memory: null,
    ),
    const BelovedOnesListPage(),
    const ProfileDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationBlocState>(
        builder: (context, state) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: IndexedStack(
            index: state.index,
            children: _pages,
          ),
          bottomNavigationBar: GriotBottomNavigationBar(
            currentIndex: state.index,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  context.read<NavigationBloc>().add(DashboardClickedEvent());
                  break;
                case 1:
                  context
                      .read<NavigationBloc>()
                      .add(MemoriesListClickedEvent());
                  break;
                case 2:
                  context
                      .read<NavigationBloc>()
                      .add(MemoriesCreationClickedEvent());
                  context
                      .read<MemoryManipulationBlocBloc>()
                      .add(const CreateNewMemoryClickedEvent());
                  break;
                case 3:
                  context
                      .read<NavigationBloc>()
                      .add(BelovedOnesListClickedEvent());
                  break;
                case 4:
                  context
                      .read<NavigationBloc>()
                      .add(ProfileDetailsClickedEvent());
                  break;
              }
            },
          ),
        ),
      );
    });
  }
}
