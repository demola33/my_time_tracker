import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    @required this.text,
    this.color = Colors.black,
    this.fontWeight,
    this.heightRatio,
    Key key,
  }) : super(key: key);

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double heightRatio;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
        fontSize: size.height * 0.03,
        color: color,
      ),
    );
  }
}
