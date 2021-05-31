import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.restorationId,
    this.fieldKey,
    this.errorText,
    this.maxLength,
    //this.onSaved,
    this.onEditingComplete,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    @required this.focusNode,
    this.passwordController,
    this.enabled,
    this.textInputAction,
    this.helperText,
    @required this.reTypePassword,
  });

  final String restorationId;
  final Key fieldKey;
  final int maxLength;
  final Function(String) onChanged;
  final String errorText;
  final bool enabled;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final String helperText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final bool reTypePassword;
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
    return TextField(
      key: widget.fieldKey,
      controller: widget.passwordController,
      focusNode: widget.focusNode,
      obscureText: _obscureText.value,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      //onSaved: widget.onSaved,
      //: widget.validator,
      //onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.teal[700],
          size: size.height * 0.05,
        ),
        labelText: widget.reTypePassword ? 'Confirm Password' : 'Password',
        labelStyle: CustomTextStyles.textStyleBold(),
        helperText: widget.helperText,
        errorText: widget.errorText,
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
