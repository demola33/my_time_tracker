import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPInputBox extends StatelessWidget {
  const OTPInputBox(
      {Key key,
      @required this.onSubmit,
      @required this.controller,
      @required this.enabled})
      : super(key: key);

  final void Function(String) onSubmit;
  final TextEditingController controller;
  final bool enabled;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.teal, width: 3.0),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinPut(
      fieldsCount: 6,
      onSubmit: onSubmit,
      onSaved: (String pin) {},
      enabled: enabled,
      autofocus: true,
      textStyle: CustomTextStyles.textStyleBold(),
      preFilledWidget: const Icon(
        Icons.emoji_objects_rounded,
        color: Colors.teal,
      ),
      controller: controller,
      submittedFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(20.0),
      ),
      selectedFieldDecoration: _pinPutDecoration,
      followingFieldDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.deepOrangeAccent, width: 1.5),
      ),
      disabledDecoration: _pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
