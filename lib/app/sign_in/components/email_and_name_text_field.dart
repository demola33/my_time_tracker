import 'package:flutter/material.dart';

class EmailNameSignInTextField extends StatelessWidget {
  const EmailNameSignInTextField({
    Key key,
    @required this.labelText,
    this.hint,
    @required this.icon,
    this.suffixIcon,
    @required this.errorText,
    @required this.focusNode,
    @required this.controller,
    @required this.keyboardType,
    @required this.textInputAction,
    @required this.onChanged,
    @required this.onEditingComplete,
    this.enabled,
    this.textCapitalization,
  }) : super(key: key);

  final String labelText;
  final String hint;
  final IconData icon;
  final IconData suffixIcon;
  final String errorText;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function() onEditingComplete;
  final TextCapitalization textCapitalization;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hint,
        labelStyle: TextStyle(
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.bold,
          fontSize: size.height * 0.025,
        ),
        icon: Icon(
          icon,
          color: Colors.teal[700],
          size: size.height * 0.05,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: Colors.teal[700],
        ),
        errorText: errorText,
        enabled: enabled,
      ),
    );
  }
}
