import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          disabledColor: color,
          color: color,
          onPressed: onPressed,
        );
}
