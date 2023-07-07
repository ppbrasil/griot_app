import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GriotAddVideosButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GriotAddVideosButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xff51ac87),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99.0),
        ),
      ),
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            'Add another video',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
