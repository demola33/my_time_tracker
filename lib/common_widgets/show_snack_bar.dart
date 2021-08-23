import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

class MyCustomSnackBar {
  final String text;
  final VoidCallback onPressed;

  MyCustomSnackBar({@required this.text, this.onPressed});

  ScaffoldMessengerState show(BuildContext context) {
    return ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(
            text,
            style: CustomTextStyles.textStyleBold(
              color: Colors.deepOrangeAccent,
            ),
          ),
        ),
      );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showPlusUndo(
      BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        content: Text(
          text,
          style: CustomTextStyles.textStyleBold(
            color: Colors.deepOrangeAccent,
          ),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
