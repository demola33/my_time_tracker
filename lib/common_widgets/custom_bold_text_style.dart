import 'package:flutter/material.dart';

class CustomBoldTextStyle extends StatelessWidget {
  const CustomBoldTextStyle({
    @required this.text,
    Key key,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceSansPro',
        fontSize: size.height * 0.03,
      ),
    );
  }
}
