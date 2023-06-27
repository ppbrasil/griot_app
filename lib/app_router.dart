import 'package:flutter/material.dart';
import 'package:griot_app/authentication/presentation/pages/login_page.dart';
import 'package:griot_app/accounts/presentation/pages/beloved_ones_details_page.dart';
import 'package:griot_app/accounts/presentation/pages/beloved_ones_list_page.dart';
import 'package:griot_app/core/presentation/pages/dashboard.dart';
import 'package:griot_app/core/presentation/pages/home_page.dart';
import 'package:griot_app/griot_app.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/pages/memories_list_page.dart';
import 'package:griot_app/memories/presentation/pages/memories_manipulation_page.dart';
import 'package:griot_app/profile/presentation/pages/profile_details_page.dart';
import 'package:griot_app/splash_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home_page':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/auth_layer':
        return MaterialPageRoute(builder: (_) => const AuthenticationLayer());
      case '/app_layer':
        return MaterialPageRoute(builder: (_) => const AppLayer());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case '/memories_list_page':
        return MaterialPageRoute(builder: (_) => const MemoriesListPage());
      case '/memories_details_page':
        if (settings.arguments is Memory) {
          return MaterialPageRoute(
            builder: (_) =>
                MemoryManipulationPage(memory: settings.arguments as Memory),
          );
        }
        throw const RouteException(
            'Arguments for /memories_details_page must be of type Memory');

      case '/memories_creation_page':
        if (settings.arguments is Memory) {
          return MaterialPageRoute(
            builder: (_) =>
                MemoryManipulationPage(memory: settings.arguments as Memory),
          );
        }
        throw const RouteException(
            'Arguments for /memories_creation_page must be of type Memory');

      case '/beloved_ones_list_page':
        return MaterialPageRoute(builder: (_) => const BelovedOnesListPage());
      case '/beloved_ones_details_page':
        return MaterialPageRoute(
            builder: (_) => const BelovedOnesDetailsPage());
      case '/profile_details_page':
        return MaterialPageRoute(builder: (_) => const ProfileDetailsPage());
      default:
        throw const RouteException('Route not found');
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
