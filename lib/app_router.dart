import 'package:flutter/material.dart';
import 'package:griot_app/authentication/presentation/pages/login_page.dart';
import 'package:griot_app/beloved_ones/presentation/pages/beloved_ones_details_page.dart';
import 'package:griot_app/beloved_ones/presentation/pages/beloved_ones_list_page.dart';
import 'package:griot_app/core/presentation/pages/dashboard.dart';
import 'package:griot_app/core/presentation/pages/home_page.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/pages/memories_creation_page.dart';
import 'package:griot_app/memories/presentation/pages/memories_details_page.dart';
import 'package:griot_app/memories/presentation/pages/memories_list_page.dart';
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
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case '/memories_list_page':
        return MaterialPageRoute(builder: (_) => const MemoriesListPage());
      case '/memories_details_page':
        if (settings.arguments is Memory) {
          return MaterialPageRoute(
            builder: (_) =>
                MemoryDetailsPage(memory: settings.arguments as Memory),
          );
        }
        throw const RouteException(
            'Arguments for /memories_details_page must be of type Memory');

      case '/memories_creation_page':
        return MaterialPageRoute(builder: (_) => const MemoriesCreationPage());
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
