import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
          ),
          fillColor: const Color(0xFFA66E38).withOpacity(0.3),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF3F2917).withOpacity(0.5)),
        ),
      ),
    );
  }
}
