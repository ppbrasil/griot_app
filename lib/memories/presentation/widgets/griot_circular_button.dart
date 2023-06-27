import 'package:flutter/material.dart';

class GriotCircularButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GriotCircularButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xff51ac87),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
