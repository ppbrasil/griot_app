import 'package:flutter/material.dart';
import 'package:griot_app/core/app_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> _loadDependencies(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDependencies(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 180,
                  height: 149,
                  child: Image.asset(
                    'assets/vertical@3x - F3F3F3 - White Smoke.png',
                    width: 180,
                    height: 149,
                  ),
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 81, 172, 135));
        } else {
          return Container(); // Or any error widget in case of snapshot.hasError
        }
      },
    );
  }
}
