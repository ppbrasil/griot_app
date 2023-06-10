import 'package:flutter/material.dart';
import 'package:griot_app/accounts/presentation/pages/accounts_list_page.dart';
import 'package:griot_app/authentication/presentation/pages/login_page.dart';
import 'package:griot_app/splash_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/accounts_list':
        return MaterialPageRoute(builder: (_) => const AccountsListPage());
      default:
        throw const RouteException('Route not found');
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
