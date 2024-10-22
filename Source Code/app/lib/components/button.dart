import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTapLogIn;

  const CustomButton({super.key, required this.onTapLogIn});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapLogIn,
      child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: const Color(0xFFA66E38),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Center(
            child: Text(
              "Log In",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
