import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

import '/config/constants.dart';

class CustomTextFieldWithIconButton extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final void Function()? onTap;
  final void Function()? onTapIcon;
  final IconData? suffix;
  final IconData? prefix;
  final int maxLines;
  final int minLines;
  final double top;
  final double bottom;

  const CustomTextFieldWithIconButton({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.onTap,
    required this.onTapIcon,
    required this.suffix,
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
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 22, 16, 16)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: WoofCareColors.primaryTextAndIcons),
          ),
          fillColor: const Color(0xFFA66E38).withValues(alpha: 0.3),
          filled: true,
          hintText: hintText,
          suffixIcon: IconButton(icon: Icon(suffix), onPressed: onTapIcon),
          prefixIcon: Icon(prefix),
          hintStyle: TextStyle(
            color: const Color(0xFF3F2917).withValues(alpha: 0.5),
            fontWeight: FontWeight.w200,
            fontSize: 13,
          ),
        ),
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }
}
