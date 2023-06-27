import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GriotActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GriotActionButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
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
              label,
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
      ),
    );
  }
}
