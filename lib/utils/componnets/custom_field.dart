// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;

  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? style;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? border;
  final BoxConstraints? constraints;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final double? height;
  const CustomTextField({
    Key? key,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.prefixIcon,
    this.filled,
    this.fillColor,
    this.focusedBorder,
    this.enabledBorder,
    this.border,
    this.constraints,
    this.suffixIcon,
    this.validator,
    this.labelText,
    this.style,
    this.height = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: hintStyle,
        border: border,
        focusedBorder: focusedBorder,
        filled: filled,
        fillColor: fillColor,
        enabledBorder: enabledBorder,
        constraints: constraints,
      ),
    );
  }
}
