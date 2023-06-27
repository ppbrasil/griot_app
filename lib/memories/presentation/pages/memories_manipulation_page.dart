import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';
import 'package:griot_app/memories/presentation/widgets/griot_custom_text_form_field.dart';

class MemoryManipulationPage extends StatefulWidget {
  final Memory memory;

  const MemoryManipulationPage({super.key, required this.memory});

  @override
  State<MemoryManipulationPage> createState() => _MemoryManipulationPage();
}

class _MemoryManipulationPage extends State<MemoryManipulationPage> {
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MemoryManipulationBlocBloc>(),
      child:
          BlocBuilder<MemoryManipulationBlocBloc, MemoryManipulationBlocState>(
        builder: (context, state) {
          if (state is MemoryCreationBlocInitial) {
            BlocProvider.of<MemoryManipulationBlocBloc>(context)
                .add(GetMemoryDetailsEvent(memoryId: widget.memory.id!));
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemoryManipulationSuccessState ||
              state is MemoryManipulationFailureState) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Space
                    const Spacer(flex: 1),
                    // Title
                    GriotCustomTextInputField(
                      fieldType: GriotCustomTextInputFieldType.title,
                      icon: null,
                      label: 'Title',
                      textController: titleController,
                    ),
                    // Space
                    const Spacer(flex: 7),
                    // Video List
                    Container(),
                    // Space
                    const Spacer(flex: 7),
                    // addvideo error message
                    Container(),
                    // Space
                    const Spacer(flex: 7),
                    // Add Video Button
                    Container(),
                    // Space
                    const Spacer(flex: 7),
                    // Save/Update error message
                    Container(),
                    // Space
                    const Spacer(flex: 7),
                    // Save Button
                    Container(),
                    // Space
                    const Spacer(flex: 7),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
