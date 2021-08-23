import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String text,
    @required FocusNode focusNode,
    VoidCallback onPressed,
  }) : super(
            child: Text(
              text,
              style: CustomTextStyles.textStyleBold(fontSize: 15),
            ),
            color: Colors.teal[600],
            onPressed: onPressed,
            disabledColor: Colors.teal[600],
            focusNode: focusNode);
}
