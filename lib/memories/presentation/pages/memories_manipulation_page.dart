import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';
import 'package:griot_app/core/presentation/widgets/griot_app_bar.dart';
import 'package:griot_app/injection_container.dart';
import 'package:griot_app/memories/domain/entities/memory.dart';
import 'package:griot_app/memories/presentation/bloc/memory_manipulation_bloc_bloc.dart';
import 'package:griot_app/memories/presentation/widgets/griot_action_button.dart';
import 'package:griot_app/memories/presentation/widgets/griot_circular_button.dart';
import 'package:griot_app/memories/presentation/widgets/griot_custom_text_form_field.dart';
import 'package:griot_app/memories/presentation/widgets/griot_error_text_field.dart';
import 'package:griot_app/memories/presentation/widgets/griot_video_list.dart';

class MemoryManipulationPage extends StatefulWidget {
  final Memory? memory;

  const MemoryManipulationPage({super.key, required this.memory});

  @override
  State<MemoryManipulationPage> createState() => _MemoryManipulationPage();
}

class _MemoryManipulationPage extends State<MemoryManipulationPage> {
  final TextEditingController titleController = TextEditingController();
  String savingErrorMessage = '';
  String videoAddingErrorMessage = '';

  void _commit(BuildContext context) {
    final myState = context.read<MemoryManipulationBlocBloc>().state;
    Memory commitingMemory =
        myState.memory!.copyWith(title: titleController.text);
    BlocProvider.of<MemoryManipulationBlocBloc>(context)
        .add(CommitMemoryEvent(memory: commitingMemory));
  }

  void _addVideo(BuildContext context) {
    final myState = context.read<MemoryManipulationBlocBloc>().state;
    BlocProvider.of<MemoryManipulationBlocBloc>(context)
        .add(AddVideoClickedEvent(memory: myState.memory!));
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: BlocProvider(
        create: (context) => sl<MemoryManipulationBlocBloc>(),
        child: BlocBuilder<MemoryManipulationBlocBloc,
            MemoryManipulationBlocState>(
          builder: (context, state) {
            if (state is MemoryCreationBlocInitial) {
              if (widget.memory != null) {
                BlocProvider.of<MemoryManipulationBlocBloc>(context)
                    .add(GetMemoryDetailsEvent(memoryId: widget.memory!.id!));
                return const Center(child: CircularProgressIndicator());
              } else {
                BlocProvider.of<MemoryManipulationBlocBloc>(context)
                    .add(const CreateNewMemoryClickedEvent());
                return const Center(child: CircularProgressIndicator());
              }
            } else if (state is MemoryManipulationSuccessState ||
                state is MemoryManipulationFailureState) {
              if (state is MemoryManipulationFailureState) {
                savingErrorMessage = state.savingErrorMesssage;
                videoAddingErrorMessage = state.videoAddingErrorMesssage;
              }
              return Scaffold(
                appBar: GriotAppBar(
                  title: state.memory!.title! != ''
                      ? state.memory!.title!
                      : 'unnamed memory',
                  automaticallyImplyLeading: true,
                ),
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
                        label: state.memory!.title!,
                        textController: titleController,
                      ),
                      // Space
                      const Spacer(flex: 1),
                      // Video List, Spacer, Error message, Spacer, and Add Video Button wrapped in Expanded and SingleChildScrollView
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 65,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Video List - removed Expanded
                              const GriotVideoList(),
                              // Space
                              const SizedBox(),
                              // addvideo error message
                              ErrorTextField(
                                  errorMessage: videoAddingErrorMessage),
                              // Space
                              const SizedBox(),
                              // Add Video Button
                              GriotAddVideosButton(
                                  onPressed: () => _addVideo(context)),
                            ],
                          ),
                        ),
                      ),
                      // Space
                      const Spacer(flex: 3),
                      // Save/Update error message
                      ErrorTextField(errorMessage: savingErrorMessage),
                      // Space
                      const Spacer(flex: 1),
                      // Save Button
                      GriotActionButton(
                        label: 'Save',
                        onPressed: () => _commit(context),
                      ),
                      // Space
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
