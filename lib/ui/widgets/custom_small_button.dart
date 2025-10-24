import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color? color;
  final double? fontSize;
  final Color? fontColor;
  final double padding;
  final double margin;
  final double borderRadius;
  final double edgeSymmetricHorizontal;
  final double edgeSymmetricVertical;
  final double edgeInstetAll;
  final FontWeight? fontWeight;

  const CustomSmallButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 120.0, 
    this.height,
    this.color = const Color(0xFFA66E38),
    this.fontSize = 16,
    this.fontColor = const Color(0xFFF7FFF7),
    this.padding = 12,
    this.margin = 10,
    this.borderRadius = 16,
    this.edgeSymmetricHorizontal = 20.0,
    this.edgeSymmetricVertical = 0.0,
    this.edgeInstetAll = 10.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
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
    );
  }
}
