import 'package:flutter/material.dart';

enum ActionTextType { l, m, s }

class ActionTexts extends StatelessWidget {
  final String text;
  final ActionTextType type;
  final Color color;
  final TextAlign? textAlign;

  const ActionTexts({super.key, required this.text, required this.type, required this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _getTextStyle(type, color);
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
    );
  }

  TextStyle _getTextStyle(ActionTextType type, Color color) {
    switch (type) {
      case ActionTextType.l:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400, // Regular weight
          fontSize: 14,
          height: 17 / 14, // Line height ratio
          letterSpacing: 0.0,
          color: color,
        );
      case ActionTextType.m:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400, // Regular weight
          fontSize: 12,
          height: 15 / 12, // Line height ratio
          letterSpacing: 0.0, 
          color: color,
        );
      case ActionTextType.s:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400, // Regular weight
          fontSize: 10,
          height: 12 / 10, // Line height ratio
          letterSpacing: 0.0,
          color: color,
        );
    }
  }
}
