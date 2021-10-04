import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key key,
    this.child,
    this.color,
    this.disabledColor,
    this.borderRadius = 4.0,
    this.height = 40.0,
    this.onPressed,
    this.focusNode,
  })  : assert(borderRadius != null),
        assert(height != null), super(key: key);
  final Widget child;
  final Color color;
  final Color disabledColor;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.066 ?? this.height,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) => 10.0),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) => const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => Colors.deepOrangeAccent),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              Color stateColor;
              if (states.contains(MaterialState.disabled)) {
                stateColor = disabledColor;
              } else {
                stateColor = color;
              }
              return stateColor;
            },
          ),
        ),
        child: child,
        onPressed: onPressed,
        focusNode: focusNode,
      ),
    );
  }
}
