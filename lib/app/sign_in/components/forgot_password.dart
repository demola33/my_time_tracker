import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key key, this.press}) : super(key: key);

  final Function press;
  final buttonTextPadding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Padding(
        padding: buttonTextPadding,
        child: Text(
          'Forgot Password',
          style: CustomTextStyles.textStyleBold(
            fontSize: 13,
            color: Colors.deepOrangeAccent.shade700,
          ),
        ),
      ),
    );
  }
}
