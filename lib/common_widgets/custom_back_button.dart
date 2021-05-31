import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFFFF7043),
      child: Expanded(
        child: Text(
          'Back',
          style: CustomTextStyles.textStyleBold(),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      onPressed: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Navigator.pop(context);
      },
    );
  }
}
