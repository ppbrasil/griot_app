import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';

class ErrorTextField extends StatelessWidget {
  final String errorMessage;
  const ErrorTextField({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
      builder: (context, state) {
        if (state is MemoryManipulationFailureState) {
          return SizedBox(
            width: 200,
            height: 50,
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
