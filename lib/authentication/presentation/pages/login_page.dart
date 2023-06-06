/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/blocs/authentication/auth_bloc.dart';
import 'package:griot_app/authentication/presentation/blocs/auth_event.dart';
import 'package:griot_app/authentication/presentation/widgets/email_field.dart';
import 'package:griot_app/authentication/presentation/widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmailField(controller: _emailController),
            const SizedBox(height: 8.0),
            PasswordField(controller: _passwordController),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      LoginAttemptEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
*/