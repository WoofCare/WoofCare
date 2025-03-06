import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double edgeSymmetricHorizontal;
  final double edgeSymmetricVertical;
  final double edgeInstetAll;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.edgeSymmetricHorizontal = 20.0,
    this.edgeSymmetricVertical = 0.0,
    this.edgeInstetAll = 20.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(edgeInstetAll),
        margin: EdgeInsets.symmetric(horizontal: edgeSymmetricHorizontal, vertical: edgeSymmetricVertical),
        decoration: BoxDecoration(
          color: const Color(0xFFA66E38),
          borderRadius: BorderRadius.circular(8.0),
        ),
        
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
