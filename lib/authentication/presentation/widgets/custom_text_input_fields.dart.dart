import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/authentication/presentation/bloc/login_form_validation_bloc_bloc.dart';

enum CustomTextInputFieldType { email, password }

class CustomTextInputField extends StatefulWidget {
  final IconData icon;
  final String label;
  final TextEditingController textController;
  final LoginFormValidationBloc loginFormValidationBloc;
  final CustomTextInputFieldType fieldType;

  const CustomTextInputField({
    super.key,
    required this.icon,
    required this.label,
    required this.textController,
    required this.loginFormValidationBloc,
    required this.fieldType,
  });

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late bool isObscure = widget.fieldType == CustomTextInputFieldType.password;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormValidationBloc, LoginFormValidationBlocState>(
        bloc: widget.loginFormValidationBloc,
        builder: (context, state) {
          String? errorMessage;
          if (state is LoginFormValidationFailedState) {
            if (widget.fieldType == CustomTextInputFieldType.email) {
              errorMessage = state.usernameErrorMessage;
            } else if (widget.fieldType == CustomTextInputFieldType.password) {
              errorMessage = state.passwordErrorMessage;
            } else {
              errorMessage = null;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 5),
            child: TextFormField(
              controller: widget.textController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => errorMessage,
              onChanged: (value) {
                if (widget.fieldType == CustomTextInputFieldType.email) {
                  widget.loginFormValidationBloc
                      .add(EmailChanged(username: value));
                } else if (widget.fieldType ==
                    CustomTextInputFieldType.password) {
                  widget.loginFormValidationBloc
                      .add(PasswordChanged(password: value));
                }
              },
              style: const TextStyle(
                  color: Color.fromARGB(255, 7, 103, 103),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300),
              obscureText: isObscure,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 19),
                isDense: true,
                hintText: widget.label,
                hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 173, 164, 165),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                prefixIcon: Icon(
                  widget.icon,
                  size: 18,
                  color: const Color.fromARGB(255, 173, 164, 165),
                ),
                suffixIcon:
                    widget.fieldType == CustomTextInputFieldType.password
                        ? IconButton(
                            onPressed: () => {
                              setState(() {
                                isObscure = !isObscure;
                              })
                            },
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: const Color.fromARGB(255, 173, 164, 165),
                            ),
                          )
                        : null,
                errorStyle: const TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 3,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
