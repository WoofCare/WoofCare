import 'package:flutter/material.dart';

import '/config/constants.dart';

class CustomAlternateTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final void Function(String) onChanged;
  final int minLines;
  final int maxLines;

  const CustomAlternateTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        minLines: minLines,
        maxLines: maxLines,
        controller: controller,
        obscureText: obscureText,
        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
        onChanged: (text) {
          onChanged(text);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Colors.black, // Black border color
              width: 2.0, // Border width
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Colors.black, // Black border when enabled but not focused
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Colors.black, // Black border when the field is focused
              width: 2.0,
            ),
          ),
          fillColor:
              const Color.fromARGB(255, 255, 219, 186).withValues(alpha: 0.3),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF3F2917).withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
