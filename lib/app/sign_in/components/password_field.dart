import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key key,
    this.restorationId,
    this.errorText,
    this.maxLength,
    this.autofocus = false,
    this.fillColor = Colors.white,
    this.onSaved,
    this.onEditingComplete,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.onFieldSubmitted,
    @required this.focusNode,
    this.passwordController,
    this.enabled = true,
    this.textInputAction,
    this.helperText,
    @required this.labelText,
  }) : super(key: key);

  final String restorationId;
  //final Key fieldKey;
  final String labelText;
  final int maxLength;
  final void Function(String) onChanged;
  final void Function(String) onSaved;
  final String errorText;
  final bool enabled;
  final Color fillColor;
  final bool autofocus;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function() onEditingComplete;
  final String helperText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final TextEditingController passwordController;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> with RestorationMixin {
  final RestorableBool _obscureText = RestorableBool(true);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFormField(
      //key: key,
      validator: widget.validator,
      controller: widget.passwordController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      obscureText: _obscureText.value,
      maxLength: widget.maxLength,
      onSaved: widget.onSaved,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: widget.fillColor,
        border: const OutlineInputBorder(),
        icon: Icon(
          Icons.lock,
          color: Colors.teal[700],
          size: size.height * 0.05,
        ),
        labelText: widget.labelText,
        labelStyle: CustomTextStyles.textStyleBold(),
        helperText: widget.helperText,
        helperStyle: CustomTextStyles.textStyleNormal(fontSize: 11),
        errorText: widget.errorText,
        errorMaxLines: 2,
        errorStyle: CustomTextStyles.textStyleNormal(
            fontSize: 11, color: Colors.redAccent),
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText.value = !_obscureText.value;
            });
          },
          child: Icon(
            _obscureText.value ? Icons.visibility : Icons.visibility_off,
            semanticLabel:
                _obscureText.value ? 'Show Password' : 'Hide Password',
          ),
        ),
        enabled: widget.enabled,
      ),
    );
  }
}
