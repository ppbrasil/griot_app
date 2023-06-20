import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/presentation/bloc/profile_bloc_bloc.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBlocBloc>(context)
        .add(const GetProfileDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Memories List'),
      ),
      body: BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
          builder: (context, state) {
        if (state is ProfileGetDetailsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileGetDetailsSuccess) {
          final profile = state.profile;
          return Center(
            child: Text(profile.name!),
          );
        } else if (state is ProfileGetDetailsFailure) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
