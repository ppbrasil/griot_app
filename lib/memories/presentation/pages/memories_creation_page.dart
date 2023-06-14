import 'package:flutter/material.dart';

class MemoriesCreationPage extends StatefulWidget {
  const MemoriesCreationPage({super.key});

  @override
  State<MemoriesCreationPage> createState() => _MemoriesCreationPageState();
}

class _MemoriesCreationPageState extends State<MemoriesCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Memory creation'),
      ),
      body: const Center(),
    );
  }
}
