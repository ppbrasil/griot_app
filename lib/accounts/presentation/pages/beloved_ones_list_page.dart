import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:griot_app/accounts/presentation/bloc/beloved_ones_bloc_bloc.dart';
import 'package:griot_app/core/presentation/pages/base_page.dart';

class BelovedOnesListPage extends StatefulWidget {
  const BelovedOnesListPage({super.key});

  @override
  State<BelovedOnesListPage> createState() => _BelovedOnesListPageState();
}

class _BelovedOnesListPageState extends State<BelovedOnesListPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BelovedOnesBlocBloc>(context)
        .add(GetBelovedOnesListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Beloved Ones'),
        ),
        body: BlocBuilder<BelovedOnesBlocBloc, BelovedOnesBlocState>(
          builder: (context, state) {
            if (state is BelovedOnesBlocLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BelovedOnesBlocSuccess) {
              return ListView.builder(
                itemCount: state.belovedOnesList.length,
                itemBuilder: (context, index) {
                  final beloved = state.belovedOnesList[index];
                  return Text(beloved.name ?? 'nops');
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
