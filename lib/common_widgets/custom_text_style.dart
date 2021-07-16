import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/letter_spacing.dart';

class CustomTextStyles {
  static String _fontFamily = 'SourceSansPro';

  static TextStyle textStyleBold({
    final Color color,
    final FontWeight fontWeight: FontWeight.bold,
    final double fontSize: 15.0,
  }) {
    return TextStyle(
      letterSpacing: letterSpacingOrNone(1.0),
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle textStyleHeader({
    final FontWeight fontWeight: FontWeight.w600,
    final double fontSize: 30.0,
    final Color color: Colors.deepOrangeAccent,
  }) {
    return TextStyle(
        fontFamily: _fontFamily,
        fontWeight: fontWeight,
        letterSpacing: letterSpacingOrNone(1.0),
        fontSize: fontSize,
        color: color);
  }

  static TextStyle textStyleTitle({
    final FontWeight fontWeight: FontWeight.w600,
    final double fontSize: 21.0,
    final Color color: Colors.white,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacingOrNone(1.0),
      color: color,
    );
  }

  static TextStyle textStyleNormal({
    final FontWeight fontWeight: FontWeight.w100,
    final double fontSize: 15.0,
    final Color color: Colors.black54,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      letterSpacing: letterSpacingOrNone(1.0),
      fontSize: fontSize,
      color: color,
    );
  }
}
