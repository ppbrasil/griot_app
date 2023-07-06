import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';

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
      // Inside the builder function for AuthBlocBloc, return another BlocConsumer for ConnectivityBlocBloc.
      return BlocConsumer<ConnectivityBlocBloc, ConnectivityBlocState>(
        listener: (context, state) {
          if (state is ConnectivityBlocDisconnected) {
            // Implement your logic for ConnectivityBlocDisconnected here.
          }
        },
        builder: (context, state) {
          return child;
        },
      );
    });
  }
}