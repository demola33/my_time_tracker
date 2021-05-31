import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class MyCustomSnackBar {
  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  MyCustomSnackBar(
      {@required this.text, this.onPressed, @required this.enabled});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context) {
    SnackBarAction preferredSnackBar() {
      if (enabled == true) {
        return SnackBarAction(
          label: 'UNDO',
          onPressed: onPressed,
        );
      } else {
        return null;
      }
    }

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
          style: CustomTextStyles.textStyleBold(),
        ),
        action: preferredSnackBar(),
      ),
    );
  }
}
