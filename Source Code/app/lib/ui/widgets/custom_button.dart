import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color? color;
  final double? fontSize;
  final Color? fontColor;
  // final double padding;
  final double margin;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.color = const Color(0xFFA66E38),
    this.fontSize = 18,
    this.fontColor = const Color(0xFFF7FFF7),
    this.margin = 20,
    this.borderRadius = 8,
    this.horizontalPadding = 20,
    this.verticalPadding = 20,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
