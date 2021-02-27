import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFFFF7043),
      child: Icon(Icons.arrow_back),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          topLeft: Radius.circular(
            20.0,
          ),
        ),
      ),
      onPressed: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        Navigator.pop(context);
      },
    );
  }
}
