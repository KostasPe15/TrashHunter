// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum BodyTextType { xl, l, m, s, xs, xs_bold, s_bold, m_bold, l_bold }

class BodyTexts extends StatelessWidget {
  final String text;
  final BodyTextType type;
  final Color color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;

  const BodyTexts({super.key, required this.text, required this.type, required this.color, this.textAlign, this.fontWeight,this.overflow});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _getTextStyle(type, color);
    return Text(
      text,
      style: textStyle,
      overflow: overflow,
      textAlign: textAlign,
    );
    
  }
    TextStyle get style => _getTextStyle(type, color);

static TextStyle styleFor({
  required BodyTextType type,
  required Color color,
  FontWeight? fontWeight,
}) {
  switch (type) {
    case BodyTextType.xl:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 24 / 18,
        letterSpacing: 0.0,
        color: color,
      );
    case BodyTextType.l:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0.0,
        color: color,
      );
      case BodyTextType.l_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 16,
        height: 22 / 16,
        letterSpacing: 0.0,
        color: color,
      );
    case BodyTextType.m:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.0,
        color: color,
      );
      case BodyTextType.m_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.0,
        color: color,
      );
    case BodyTextType.s:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 1.0,
        color: color,
      );
    case BodyTextType.xs:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: FontWeight.w400,
        fontSize: 10,
        height: 14 / 10,
        letterSpacing: 1.5,
        color: color,
      );
    case BodyTextType.xs_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 10,
        height: 14 / 10,
        letterSpacing: 1.5,
        color: color,
      );
    case BodyTextType.s_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 1,
        color: color,
      );
  }
}

  TextStyle _getTextStyle(BodyTextType type, Color color) {
    switch (type) {
      case BodyTextType.xl:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          height: 24 / 18, // Line height / Font size
          letterSpacing: 0.0,
          color: color,
        );
      case BodyTextType.l:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 22 / 16,
          letterSpacing: 0.0,
          color: color,
        );
        case BodyTextType.l_bold:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: fontWeight ?? FontWeight.w700,
          fontSize: 16,
          height: 22 / 16,
          letterSpacing: 0.0,
          color: color,
        );
      case BodyTextType.m:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 20 / 14,
          letterSpacing: 0.0,
          color: color,
        );
        case BodyTextType.m_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.0,
        color: color,
      );
      case BodyTextType.s:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          height: 16 / 12,
          letterSpacing: 1.0, // Matches Figma
          color: color,
        );
      case BodyTextType.xs:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: FontWeight.w400,
          fontSize: 10,
          height: 14 / 10,
          letterSpacing: 1.5,
          color: color,
        );

        case BodyTextType.xs_bold:
        return TextStyle(
          fontFamily: 'ZonaPro',
          fontWeight: fontWeight ?? FontWeight.w700,
          fontSize: 10,
          height: 14 / 10,
          letterSpacing: 1.5,
          color: color,
        );

        case BodyTextType.s_bold:
      return TextStyle(
        fontFamily: 'ZonaPro',
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 1,
        color: color,
      );
    }
    
  }
}
