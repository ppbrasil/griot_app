import 'package:flutter/material.dart';

class GriotAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String title;

  const GriotAppBar({
    super.key,
    required this.automaticallyImplyLeading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading ? _customBackButton(context) : null,
      title: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1D1617)),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      titleSpacing: NavigationToolbar.kMiddleSpacing,
      elevation: 0,
    );
  }

  Widget _customBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
