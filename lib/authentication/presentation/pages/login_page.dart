import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/login_form_validation_bloc_bloc.dart';

import 'package:griot_app/authentication/presentation/widgets/action_button.dart';
import 'package:griot_app/authentication/presentation/widgets/custom_text_input_fields.dart.dart';
import 'package:griot_app/core/services/field_validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late LoginFormValidationBloc loginFormValidationBloc;
  ValidationService validationService = ValidationService();

  @override
  void initState() {
    super.initState();
    loginFormValidationBloc =
        LoginFormValidationBloc(validationService: validationService);
  }

  void _login(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;

    BlocProvider.of<AuthBloc>(context)
        .add(SignInWithCredentials(username: email, password: password));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    loginFormValidationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authorized) {
          Navigator.pushNamed(context, '/app_layer');
        }
      },
      builder: (context, state) {
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
                  const Spacer(flex: 4),
                  // input fields
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // email Filed
                      CustomTextInputField(
                        textController: emailController,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        loginFormValidationBloc: loginFormValidationBloc,
                        fieldType: CustomTextInputFieldType.email,
                      ),

                      // Password fields
                      CustomTextInputField(
                        textController: passwordController,
                        icon: Icons.lock_outlined,
                        label: 'Password',
                        loginFormValidationBloc: loginFormValidationBloc,
                        fieldType: CustomTextInputFieldType.password,
                      ),

                      // Forgot your password link
                      TextButton(
                        onPressed: () => {},
                        child: const Text(
                          'Forgot my password?',
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
                  const Spacer(flex: 1),
                  const ErrorTextField(),
                  const Spacer(flex: 3),
                  // Login Button
                  ActionButton(
                    label: 'Login',
                    onPressed: () => _login(context),
                  ),
                  const Spacer(flex: 7),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ErrorTextField extends StatelessWidget {
  const ErrorTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Error) {
          return const SizedBox(
            width: 200,
            height: 50,
            child: Text(
              'Credentials don\'t match!\nTry again or click "Forget my password"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
