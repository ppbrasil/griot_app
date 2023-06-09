import 'package:flutter/material.dart';
import 'package:griot_app/authentication/presentation/pages/login_page.dart';
import 'package:griot_app/splash_screen.dart';
// import 'package:griot_app/presentation/pages/accounts/accounts_page.dart';
// import 'package:griot_app/presentation/pages/memory/memory_page.dart';
// import 'package:griot_app/presentation/pages/details/details_page.dart';
// import 'package:griot_app/presentation/pages/beloved/beloved_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        throw const RouteException('Route not found');
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
