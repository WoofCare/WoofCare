import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
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

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.height,
    this.color = const Color(0xFFA66E38),
    this.fontSize = 18,
    this.fontColor = const Color(0xFFF7FFF7),
    this.padding = 20,
    this.margin = 20,
    this.borderRadius = 8,
    this.edgeSymmetricHorizontal = 20.0,
    this.edgeSymmetricVertical = 0.0,
    this.edgeInstetAll = 20.0,
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
            padding: EdgeInsets.all(padding),
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
