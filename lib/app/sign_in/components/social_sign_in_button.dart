import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialSignInButton extends StatelessWidget {
  SocialSignInButton({
    @required this.assetName,
    this.press,
  }) : assert(assetName != null);

  final String assetName;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        //padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: Colors.deepOrangeAccent,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          assetName,
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }
}
