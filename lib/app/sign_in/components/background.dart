import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white24,
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'images/screen/bottom-right.png',
              colorBlendMode: BlendMode.colorBurn,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'images/screen/home-top left.png',
              height: size.height * 0.5,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
