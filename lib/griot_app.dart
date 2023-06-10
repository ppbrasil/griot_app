import 'package:flutter/material.dart';
import 'package:griot_app/app_router.dart';
import 'package:griot_app/core/app_theme.dart';

class GriotApp extends StatelessWidget {
  const GriotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Griot App',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter().onGenerateRoute,
    );
  }
}
