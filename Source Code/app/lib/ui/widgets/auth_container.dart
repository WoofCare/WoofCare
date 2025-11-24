import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;

  const AuthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: WoofCareColors.secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            blurStyle: BlurStyle.normal,
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: child,
      ),
    );
  }
}
