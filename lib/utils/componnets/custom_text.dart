import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.align,
    this.size,
    this.overflow,
    this.weight,
    this.decoration,
    this.color = Colors.black,
    this.decorationColor,
  });
  final TextDecoration? decoration;
  final Color? decorationColor;
  final Color? color;
  final FontWeight? weight;
  final String text;
  final TextOverflow? overflow;
  final double? size;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        decoration: decoration,
        color: color,
        decorationColor: decorationColor,
        fontWeight: weight,
        fontSize: size,
      ),
    );
  }
}
