import 'package:flutter/material.dart';

class MemoriesDetailsPage extends StatefulWidget {
  const MemoriesDetailsPage({super.key});

  @override
  State<MemoriesDetailsPage> createState() => _MemoriesListPageState();
}

class _MemoriesListPageState extends State<MemoriesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
      ),
      body: const Center(),
    );
  }
}
