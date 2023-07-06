import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';
import 'package:griot_app/profile/domain/entities/profile.dart';
import 'package:griot_app/profile/presentation/bloc/profile_bloc_bloc.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBlocBloc>(context)
        .add(const GetProfileDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Memories List'),
        ),
        body: BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
            builder: (context, state) {
          if (state is ProfileGetDetailsLoading ||
              state is ProfileUpdateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileGetDetailsSuccess ||
              state is ProfileUpdateSuccess) {
            final profile = state.profile;
            _nameController.text =
                profile.name ?? ''; // Set the name in the controller
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Create a new Profile with the updated name and keep other properties the same
                      final updatedProfile = Profile(
                        id: profile.id,
                        profilePicture: profile.profilePicture,
                        name: _nameController
                            .text, // Get the updated name from the controller
                        middleName: profile.middleName,
                        lastName: profile.lastName,
                        birthDate: profile.birthDate,
                        gender: profile.gender,
                        language: profile.language,
                        timeZone: profile.timeZone,
                      );
                      // Trigger the UpdateProfileDetailsEvent
                      BlocProvider.of<ProfileBlocBloc>(context).add(
                          UpdateProfileDetailsEvent(profile: updatedProfile));
                    },
                    child: const Text('Update Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBlocBloc>(context).add(LogoutEvent());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileGetDetailsFailure ||
              state is ProfileUpdateFailure) {
            return const Center(
              child: Text('Wrong!'),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
