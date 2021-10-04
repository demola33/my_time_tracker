import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextStyles {
  static const String _fontFamily = 'SourceSansPro';
  static double letterSpacing = 1.0;

  static TextStyle textStyleBold({
    final Color color,
    final FontWeight fontWeight = FontWeight.bold,
    final double fontSize = 15.0,
  }) {
    return TextStyle(
      letterSpacing: letterSpacing,
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle textStyleExtraBold({
    final Color color = Colors.deepOrangeAccent,
    final FontWeight fontWeight = FontWeight.w800,
    final double fontSize = 12.5,
  }) {
    return TextStyle(
      letterSpacing: letterSpacing,
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle textStyleHeader({
    final FontWeight fontWeight = FontWeight.w600,
    final double fontSize = 30.0,
    final Color color = Colors.deepOrangeAccent,
  }) {
    return TextStyle(
        fontFamily: _fontFamily,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        color: color,);
  }

  static TextStyle textStyleTitle({
    final FontWeight fontWeight = FontWeight.w600,
    final double fontSize = 21.0,
    final Color color = Colors.white,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle textStyleNormal({
    final FontWeight fontWeight = FontWeight.w100,
    final double fontSize = 15.0,
    final Color color = Colors.black54,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontSize: fontSize,
      color: color,
    );
  }
}
