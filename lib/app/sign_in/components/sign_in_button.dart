import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_elevated_button.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({Key key,
    @required String text,
    FocusNode focusNode,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(key: key,
          child: Text(
            text,
            style: CustomTextStyles.textStyleBold(
              color: textColor,
            ),
          ),
          disabledColor: color,
          color: color,
          onPressed: onPressed,
          focusNode: focusNode,
        );
}
