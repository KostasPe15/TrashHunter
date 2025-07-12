import 'package:flutter/material.dart';
import '../TextsStyles/body_texts.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final void Function(String)? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextfield({
    super.key,
    this.controller,
    this.label,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'ZonaPro',
        fontSize: 16, // same as BodyTextType.m
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F2024), // match your default text color
      ),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        label: label != null
            ? BodyTexts(
                text: label!,
                type: BodyTextType.m,
                color: const Color(0xFF71727A),
              )
            : null,
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
