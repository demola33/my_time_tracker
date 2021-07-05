import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'custom_raised_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String text,
    @required FocusNode focusNode,
    VoidCallback onPressed,
  }) : super(
            child: Text(
              text,
              style: CustomTextStyles.textStyleBold(fontSize: 17.0),
            ),
            color: Colors.teal[600],
            height: 40.0,
            onPressed: onPressed,
            disabledColor: Colors.teal[600],
            focusNode: focusNode);
}
