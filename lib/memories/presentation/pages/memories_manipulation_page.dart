import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';
import 'package:griot_app/memories/presentation/widgets/griot_action_button.dart';
import 'package:griot_app/memories/presentation/widgets/griot_custom_text_form_field.dart';
import 'package:griot_app/memories/presentation/widgets/griot_error_text_field.dart';
import 'package:griot_app/memories/presentation/widgets/griot_video_list.dart';

class MemoryManipulationPage extends StatefulWidget {
  Memory memory;

  MemoryManipulationPage({super.key, required this.memory});

  @override
  State<MemoryManipulationPage> createState() => _MemoryManipulationPage();
}

class _MemoryManipulationPage extends State<MemoryManipulationPage> {
  final TextEditingController titleController = TextEditingController();

  void _commit(BuildContext context) {
    Memory commitingMemory =
        widget.memory.copyWith(title: titleController.text);
    BlocProvider.of<MemoryManipulationBlocBloc>(context)
        .add(CommitMemoryEvent(memory: commitingMemory));
    final myState = context.read<MemoryManipulationBlocBloc>().state;
    if (myState is MemoryManipulationSuccessState) {
      widget.memory = myState.memory!;
    }
  }

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
              appBar: AppBar(title: Text(widget.memory.title!)),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                    const GriotVideoList(),
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
                    const ErrorTextField(),
                    // Space
                    const Spacer(flex: 7),
                    // Save Button
                    GriotActionButton(
                      label: 'Save',
                      onPressed: () => _commit(context),
                    ),
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
