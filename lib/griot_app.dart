import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/accounts/presentation/bloc/beloved_ones_bloc_bloc.dart';
import 'package:griot_app/app_router.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';
import 'package:griot_app/authentication/presentation/pages/login_page.dart';
import 'package:griot_app/core/app_theme.dart';
import 'package:griot_app/core/presentation/bloc/connectivity_bloc_bloc.dart';
import 'package:griot_app/core/presentation/bloc/navigation_bloc_bloc.dart';
import 'package:griot_app/core/presentation/pages/home_page.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/presentation/bloc/memories_bloc_bloc.dart';
import 'package:griot_app/profile/presentation/bloc/profile_bloc_bloc.dart';
import 'package:griot_app/user/presentation/bloc/users_bloc_bloc.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class GriotApp extends StatelessWidget {
  const GriotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBlocBloc>(
          create: (BuildContext context) => sl<AuthBlocBloc>(),
        ),
        BlocProvider<ConnectivityBlocBloc>(
          create: (BuildContext context) => sl<ConnectivityBlocBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Griot App',
        theme: AppTheme.lightTheme,
        navigatorObservers: [routeObserver],
        onGenerateRoute: AppRouter().onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}

class AuthenticationLayer extends StatelessWidget {
  const AuthenticationLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, authState) {
        if (authState is AuthBlocAuthorizedState) {
          return BlocProvider(
            create: (context) =>
                sl<UsersBlocBloc>()..add(GetOwnedAccountsListEvent()),
            child: BlocBuilder<UsersBlocBloc, UsersBlocState>(
              builder: (context, userBlocState) {
                if (userBlocState is UsersBlocSuccess) {
                  return const AppLayer();
                } else {
                  return const CircularProgressIndicator(); // or another suitable placeholder
                }
              },
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class AppLayer extends StatelessWidget {
  const AppLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationBloc()),
        BlocProvider(create: (context) => sl<MemoriesBlocBloc>()),
        BlocProvider(create: (context) => sl<BelovedOnesBlocBloc>()),
        BlocProvider(create: (context) => sl<ProfileBlocBloc>()),
      ],
      child: const HomePage(),
      // Put your home screen or any other screen that will be shown after login here
    );
  }
}
