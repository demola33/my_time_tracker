import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(isMember ? "Already have an Account? " : "Don't Have an account? ",
            style: CustomTextStyles.textStyleBold(
                color: Colors.black, fontSize: 13)),
        TextButton(
          onPressed: press,
          child: Padding(
            padding: buttonTextPadding,
            child: Text(
              isMember ? "SIGN IN" : "SIGN UP",
              style: CustomTextStyles.textStyleBold(
                color: Colors.deepOrangeAccent.shade700,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
