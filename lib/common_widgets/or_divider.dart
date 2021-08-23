import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: Row(
        children: [
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'OR',
              style: CustomTextStyles.textStyleBold(color: Colors.white),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Colors.teal[600],
        height: 1.5,
        thickness: 1.0,
      ),
    );
  }
}
