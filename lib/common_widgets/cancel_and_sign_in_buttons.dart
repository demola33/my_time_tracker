import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/layout/letter_spacing.dart';

class CancelAndSignInButtons extends StatelessWidget {
  const CancelAndSignInButtons(
      {@required this.text, this.onPressed, this.focusNode});
  final VoidCallback onPressed;
  final String text;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final buttonTextPadding = EdgeInsets.zero;

    return Wrap(
      children: [
        ButtonBar(
          buttonPadding: null,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              onPressed: () async{
                FocusScope.of(context).requestFocus(FocusNode());
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.of(context, rootNavigator: true).pop();
                },
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  'CANCEL',
                  style: CustomTextStyles.textStyleBold(color: Colors.black),
                ),
              ),
            ),
            ElevatedButton(
              focusNode: focusNode,
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) => 10.0),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => Colors.deepOrangeAccent),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                  (Set<MaterialState> states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5);
                    else if (states.contains(MaterialState.disabled))
                      return Colors.teal[600];
                    return null;
                  },
                ),
              ),
              onPressed: onPressed,
              child: Padding(
                padding: buttonTextPadding,
                child: Text(
                  text,
                  style: TextStyle(letterSpacing: letterSpacingOrNone(1.0)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
