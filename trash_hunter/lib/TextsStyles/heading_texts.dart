import 'package:flutter/material.dart';

enum HeadingType { h1, h2, h3, h4, h5, h1_5 }

class HeadingTexts extends StatelessWidget {
  final String text;
  final HeadingType type;
  final Color color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const HeadingTexts({
    super.key,
    required this.text,
    required this.type,
    required this.color,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _getTextStyle(type, color);

    return Text(
      text,
      style: textStyle,
      softWrap: true,
      overflow: overflow ?? TextOverflow.visible,
      maxLines: 2,
      textAlign: textAlign,
    );
  }

  TextStyle _getTextStyle(HeadingType type, Color color) {
    return TextStyle(
      fontFamily: 'ZonaPro',
      fontWeight: _getFontWeight(type),
      fontSize: _getFontSize(type),
      letterSpacing: _getLetterSpacing(type),
      height: 1.0,
      color: color, 
    );
  }

  double _getFontSize(HeadingType type) {
    switch (type) {
      case HeadingType.h1:
        return 24;
      case HeadingType.h1_5:
        return 20;
      case HeadingType.h2:
        return 18;
      case HeadingType.h3:
        return 16;
      case HeadingType.h4:
        return 14;
      case HeadingType.h5:
        return 12;
    }
  }

  FontWeight _getFontWeight(HeadingType type) {
    switch (type) {
      case HeadingType.h1:
      case HeadingType.h2:
      case HeadingType.h1_5:
      case HeadingType.h3:
        return FontWeight.w800;
      case HeadingType.h4:
        return FontWeight.w700;
      case HeadingType.h5:
        return FontWeight.w700;
    }
  }

  double _getLetterSpacing(HeadingType type) {
    switch (type) {
      case HeadingType.h1:
        return 1.0;
      case HeadingType.h2:
      case HeadingType.h1_5:
      case HeadingType.h3:
        return 0.5;
      case HeadingType.h4:
      case HeadingType.h5:
        return 0.0;
    }
  }
}
