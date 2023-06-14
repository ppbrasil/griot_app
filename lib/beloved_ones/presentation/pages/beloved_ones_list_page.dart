import 'package:flutter/material.dart';

class BelovedOnesListPage extends StatefulWidget {
  const BelovedOnesListPage({super.key});

  @override
  State<BelovedOnesListPage> createState() => _BelovedOnesListPageState();
}

class _BelovedOnesListPageState extends State<BelovedOnesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Beloved Ones'),
      ),
      body: const Center(),
    );
  }
}
