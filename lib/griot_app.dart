import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/app_router.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/core/app_theme.dart';
import 'package:griot_app/core/presentation/bloc/navigation_bloc_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class GriotApp extends StatelessWidget {
  const GriotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocProvider(
        create: (context) => NavigationBloc(),
        child: BlocProvider(
          create: (context) => sl<MemoriesBlocBloc>(),
          child: MaterialApp(
            title: 'Griot App',
            theme: AppTheme.lightTheme,
            navigatorObservers: [routeObserver],
            onGenerateRoute: AppRouter().onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
