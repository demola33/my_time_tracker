import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class CustomIconTextField extends StatelessWidget {
  const CustomIconTextField({
    Key key,
    @required this.labelText,
    this.hint,
    this.icon,
    this.suffixIcon,
    this.validator,
    //this.initialValue,
    this.errorText,
    @required this.focusNode,
    this.controller,
    @required this.keyboardType,
    @required this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.onSaved,
    this.enabled,
    this.helperText,
    this.maxLength,
    this.textCapitalization: TextCapitalization.none,
  }) : super(key: key);

  final String labelText;
  final String hint;
  final IconData icon;
  final IconData suffixIcon;
  final String errorText;
  final String helperText;
  final FocusNode focusNode;
  final int maxLength;
  //final String initialValue;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function() onEditingComplete;
  final FormFieldSetter<String> onSaved;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String> validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TextFormField(
      textCapitalization: textCapitalization,
      controller: controller,
      focusNode: focusNode,
      enableSuggestions: true,
      //initialValue: initialValue,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSaved: onSaved,
      onEditingComplete: onEditingComplete,
      validator: validator,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLines: 1,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        labelText: labelText,
        hintText: hint,
        helperText: helperText,
        hintStyle: CustomTextStyles.textStyleBold(),
        labelStyle: CustomTextStyles.textStyleBold(),
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
