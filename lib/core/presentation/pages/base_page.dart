import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';
import 'package:flash/flash.dart';

class BasePage extends StatelessWidget {
  final Widget child;

  const BasePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
      if (state is AuthBlocUnauthorizedState ||
          state is AuhtBlocLoggedOutState) {
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed('/login');
      }
    }, builder: (context, state) {
      return BlocConsumer<ConnectivityBlocBloc, ConnectivityBlocState>(
        listener: (context, state) {
          if (state is ConnectivityBlocDisconnected) {
            showFlash(
              context: context,
              duration: const Duration(seconds: 4),
              builder: (context, controller) {
                return Flash(
                    dismissDirections: const [FlashDismissDirection.startToEnd],
                    controller: controller,
                    child: FlashBar(
                      position: FlashPosition.bottom,
                      content: const Text('My title'),
                      margin: const EdgeInsets.all(8),
                      controller: controller,
                    ));
              },
            );
          }
        },
        builder: (context, state) {
          return child;
        },
      );
    });
  }
}
