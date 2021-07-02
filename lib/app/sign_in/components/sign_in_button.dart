import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_raised_button.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    @required String text,
    FocusNode focusNode,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
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
