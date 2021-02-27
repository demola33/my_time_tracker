import 'package:flutter/material.dart';

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
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                color: Colors.black87,
                fontSize: 14.0,
              ),
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
        color: Colors.deepOrangeAccent,
        height: 1.5,
      ),
    );
  }
}
