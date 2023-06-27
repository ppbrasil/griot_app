import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

enum GriotCustomTextInputFieldType { title, email, password }

class GriotCustomTextInputField extends StatefulWidget {
  final IconData? icon;
  final String label;
  final TextEditingController textController;
  final GriotCustomTextInputFieldType fieldType;

  const GriotCustomTextInputField({
    super.key,
    required this.icon,
    required this.label,
    required this.textController,
    required this.fieldType,
  });

  @override
  State<GriotCustomTextInputField> createState() =>
      _GriotCustomTextInputField();
}

class _GriotCustomTextInputField extends State<GriotCustomTextInputField> {
  late bool isObscure =
      (widget.fieldType == GriotCustomTextInputFieldType.password);

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
          BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
              bloc: BlocProvider.of<MemoryManipulationBlocBloc>(context),
              builder: (context, state) {
                String? errorMessage;
                if (state is MemoryManipulationFailureState) {
                  if (widget.fieldType == GriotCustomTextInputFieldType.title) {
                    errorMessage = state.titleErrorMesssage;
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
                      BlocProvider.of<MemoryManipulationBlocBloc>(context)
                          .add(MemoryTitleChangedEvent(title: value));
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
                      suffixIcon: widget.fieldType ==
                              GriotCustomTextInputFieldType.password
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
              }),
    );
  }
}
