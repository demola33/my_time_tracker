import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool isMember;
  final Function press;
  final buttonTextPadding = EdgeInsets.zero;

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
            isMember
                ? "Already have an Account ?   "
                : "Don't Have an account ?   ",
            style: CustomTextStyles.textStyleBold(color: Colors.teal[900])),
        TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          onPressed: press,
          child: Padding(
            padding: buttonTextPadding,
            child: Text(
              isMember ? "SIGN IN" : "SIGN UP",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationThickness: 2.0,
                fontFamily: 'SourceSansPro',
                decorationColor: Colors.deepOrangeAccent,
                fontWeight: FontWeight.w900,
                color: Colors.teal[900],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
