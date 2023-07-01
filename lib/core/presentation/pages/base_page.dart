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
    return MultiBlocListener(
      listeners: [
        /*BlocListener<ConnectivityBlocBloc, ConnectivityBlocState>(
          listener: (context, state) {
            if (state is ConnectivityBlocDisconnected) {
              showFlash(
                context: context,
                duration: const Duration(seconds: 4),
                builder: (context, controller) {
                  return Flash(
                    controller: controller,
                    style: FlashStyle.grounded,
                    backgroundColor: Colors.red,
                    child: FlashBar(
                      title: const Text('You are disconnected!'),
                      message: const Text('Please check your internet connection.'),
                    ),
                  );
                },
              );
            } 
          },
        ),*/
        BlocListener<UserSessionBlocBloc, UserSessionBlocState>(
          listener: (context, state) {
            if (state is UserLostSessionEvent) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        ),
      ],
      child: child,
    );
  }
}
