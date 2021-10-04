import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({Key key,
    @required this.assetName,
    this.press,
  }) : assert(assetName != null), super(key: key);

  final String assetName;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 240, 240, 1),
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
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
