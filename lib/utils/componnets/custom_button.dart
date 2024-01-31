import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.radius = 20,
    this.color = Colors.deepPurple,
    this.boxShadow,
    this.width = double.infinity,
    required this.text,
    required this.onTap,
    this.height = 63,
    this.loading = false,
  });
  final Function()? onTap;
  final double height;
  final double width;
  final double radius;
  final Color? color;
  final List<BoxShadow>? boxShadow;
  final bool loading;

  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(
        //   vertical: 25.0,
        //   horizontal: 10.0,
        // ),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
          color: color,
        ),
        child: Center(
          child: loading
              ? const FittedBox(child: CircularProgressIndicator())
              : FittedBox(
                  child: CustomText(
                    text: text,
                    size: 14,
                    weight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
