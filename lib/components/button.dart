import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;

  const CustomButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: const Color(0xFFA66E38),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Center(
            child: Text(
              "Sign In",
              style: TextStyle(
                color: Color(0xFF3F2917),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
