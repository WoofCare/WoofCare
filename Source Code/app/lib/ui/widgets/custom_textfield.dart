import 'package:flutter/material.dart';
import 'package:woofcare/config/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final void Function()? onTap;
  final IconData? suffix;
  final IconData? prefix;
  final int maxLines;
  final int minLines;
  final double top;
  final double bottom;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.onTap,
    this.suffix,
    this.prefix,
    this.maxLines = 100,
    this.minLines = 1,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, top, 0, bottom),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color.fromARGB(255, 22, 16, 16)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
          ),
          fillColor: const Color(0xFFA66E38).withOpacity(0.3),
          filled: true,
          hintText: hintText,
          suffixIcon: Icon(suffix),
          prefixIcon: Icon(prefix),
          hintStyle: TextStyle(
            color: const Color(0xFF3F2917).withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }
}
