import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 300,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/no-internet.png")
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is switched on and Airplane Mode switched off.',
                style: CustomTextStyles.textStyleBold(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
