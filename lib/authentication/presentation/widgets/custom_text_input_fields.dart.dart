import 'package:flutter/material.dart';

class CustomTextInputField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final TextEditingController textController;

  const CustomTextInputField(
      {super.key,
      required this.icon,
      required this.label,
      required this.textController,
      this.isSecret = false});

  @override
  State<CustomTextInputField> createState() => _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  late bool isObscure;

  @override
  void initState() {
    isObscure = widget.isSecret;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: TextField(
        controller: widget.textController,
        style: const TextStyle(
            color: Color.fromARGB(255, 7, 103, 103),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300),
        obscureText: isObscure,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 19),
          isDense: true,
          hintText: widget.label,
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 173, 164, 165),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          prefixIcon: Icon(
            widget.icon,
            size: 18,
            color: const Color.fromARGB(255, 173, 164, 165),
          ),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () => {
                    setState(() {
                      isObscure = !isObscure;
                    })
                  },
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: const Color.fromARGB(255, 173, 164, 165),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
