import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

import '/config/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool autofocus;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final IconData? suffix;
  final IconData? prefix;
  final double horizontalPadding;
  final int maxLines;
  final int minLines;
  final double top;
  final double bottom;

  final void Function()? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.autofocus = false,
    this.onTap,
    this.keyboardType,
    this.suffix,
    this.prefix,
    this.onSuffixTap,
    this.horizontalPadding = 12,
    this.maxLines = 100,
    this.minLines = 1,
    this.top = 0,
    this.bottom = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: autofocus,
        obscureText: obscureText,
        style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
        onTap: onTap,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 22, 16, 16),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(
              color: WoofCareColors.primaryTextAndIcons,
            ),
          ),
          fillColor: WoofCareColors.textfieldBackground.withValues(alpha: 0.3),
          filled: true,

          //make it so no icon space is taken if no icon is provided
          suffixIcon:
              suffix != null
                  ? (onSuffixTap != null
                      ? IconButton(icon: Icon(suffix), onPressed: onSuffixTap)
                      : Icon(suffix))
                  : null,
          prefixIcon: prefix != null ? Icon(prefix) : null,

          //hint style
          hintText: hintText,
          hintStyle: TextStyle(
            color: WoofCareColors.primaryTextAndIcons.withValues(alpha: 0.5),
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
