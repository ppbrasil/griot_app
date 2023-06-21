import 'package:flutter/material.dart';

class BelovedOnesDetailsPage extends StatefulWidget {
  const BelovedOnesDetailsPage({super.key});

  @override
  State<BelovedOnesDetailsPage> createState() => _BelovedOnesDetailsPageState();
}

class _BelovedOnesDetailsPageState extends State<BelovedOnesDetailsPage> {
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
