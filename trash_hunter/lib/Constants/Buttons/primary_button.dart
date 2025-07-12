import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../TextsStyles/action_texts.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final double? width;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.width,
    required this.height,
    this.backgroundColor = Colors.black,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            //foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: ActionTexts(
              text: text, type: ActionTextType.l, color: textColor)),
    );
  }
}
