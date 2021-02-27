import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool isMember;
  final Function press;

  const AlreadyHaveAnAccountCheck({
    @required this.isMember,
    this.press,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          isMember ? "Already have an Account ?" : "Don't Have an account ?",
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            color: Colors.teal[900],
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            isMember ? "  Sign In" : "  Sign Up",
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationThickness: 2.0,
              fontFamily: 'SourceSansPro',
              fontWeight: FontWeight.w900,
              color: Colors.teal[900],
            ),
          ),
        ),
      ],
    );
  }
}
