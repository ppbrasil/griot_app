/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/core/api/api_client.dart';
import 'package:griot_app/authentication/data/repositories/auth_repository_impl.dart';
import 'package:griot_app/authentication/domain/repositories/auth_repository.dart';
import 'package:griot_app/authentication/presentation/app.dart';
import 'package:griot_app/authentication/presentation/blocs/authentication/auth_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  final AuthRepository authRepository = AuthRepositoryImpl(
    apiClient: APIClient(httpClient: http.Client()),
  );

  runApp(
    RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authRepository: authRepository),
        child: MyApp(),
      ),
    ),
  );
}
*/
