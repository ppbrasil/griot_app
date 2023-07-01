import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
//import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';
import 'package:griot_app/core/presentation/bloc/user_session_bloc_bloc.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserSessionBlocBloc, UserSessionBlocState>(
      listener: (context, state) {
        if (state is UserLostSessionState) {
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed('/login');
        }
      },
      builder: (context, state) {
        return child;
      },
    );
  }
}
