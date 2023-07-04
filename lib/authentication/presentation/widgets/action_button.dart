import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:griot_app/authentication/presentation/bloc/auth_bloc_bloc.dart';

import '../../../injection_container.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBlocBloc>(),
      child: SizedBox(
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
      ),
    );
  }
}
