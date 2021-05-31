import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_logo.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 173, 1),
      body: Center(
        child: _buildLogo(context),
      ),
    );
  }

  Widget _buildLogo(context) {
    //Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Color.fromRGBO(237, 235, 173, 1),
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              child: TimeTrackerLogo(),
              width: 200,
              height: 200,
            ),
          ),
          TextLiquidFill(
            text: 'TIME TRACKER',
            waveColor: Colors.deepOrangeAccent,
            waveDuration: const Duration(seconds: 1),
            loadDuration: const Duration(seconds: 2),
            boxBackgroundColor: Color.fromRGBO(237, 235, 173, 1),
            textStyle: CustomTextStyles.textStyleTitle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
            boxHeight: 100.0,
          ),
        ],
      ),
    );
  }
}
