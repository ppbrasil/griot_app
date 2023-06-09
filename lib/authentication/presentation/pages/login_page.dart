import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/authentication/presentation/widgets/action_button.dart';
import 'package:griot_app/authentication/presentation/widgets/custom_text_input_fields.dart.dart';
import 'package:griot_app/core/app_theme.dart';
import 'package:griot_app/injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(13, 68, 86, 1),
            Color.fromRGBO(7, 103, 103, 1),
          ], stops: <double>[
            0,
            1
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 7),
              // Logo
              SizedBox(
                width: 180,
                height: 149,
                child: Image.asset(
                  'assets/vertical@3x - F3F3F3 - White Smoke.png',
                  width: 180,
                  height: 149,
                ),
              ),
              Spacer(flex: 4),
              // input fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // email Filed
                  const CustomTextInputField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                  ),

                  // Password fields
                  const CustomTextInputField(
                    icon: Icons.lock_outlined,
                    label: 'Password',
                    isSecret: true,
                  ),

                  // Forgot your password link
                  TextButton(
                    onPressed: () => {},
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 4),
              // Login Button
              const ActionButton(label: 'Login'),
              Spacer(flex: 7),
            ],
          ),
        ),
      ),
    );
  }
}
