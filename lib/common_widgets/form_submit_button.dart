import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceSansPro',
              color: Colors.white,
            ),
          ),
          color: Colors.teal[700],
          height: 40.0,
          onPressed: onPressed,
        );
}
