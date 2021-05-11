import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
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
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) => 10.0),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => Colors.deepOrangeAccent),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return color.withOpacity(0.5);
              else if (states.contains(MaterialState.disabled))
                return disabledColor;
              return color;
            },
          ),
        ),
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
