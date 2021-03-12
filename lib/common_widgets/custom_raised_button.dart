import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color,
    this.disabledColor,
    this.borderRadius: 20.0,
    this.height: 40.0,
    this.onPressed,
  })  : assert(borderRadius != null),
        assert(height != null);
  final Widget child;
  final Color color;
  final Color disabledColor;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        disabledColor: disabledColor,
        onPressed: onPressed,
      ),
    );
  }
}
