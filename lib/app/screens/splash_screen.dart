import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/components/time_tracker_logo.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 84, 48, 1),
      body: Center(
        child: _buildLogo(context),
      ),
    );
  }

  Widget _buildLogo(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(66, 150, 152, 0.8),
                    Color.fromRGBO(255, 228, 115, 1),
                    Color.fromRGBO(66, 150, 152, 0.8),
                    Color.fromRGBO(255, 228, 115, 1),
                  ],
                ),
                color: Color.fromRGBO(0, 84, 48, 0.5),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ]),
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              child: TimeTrackerLogo(topPadding: 20),
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 50),
          TextLiquidFill(
            text: 'TIME TRACKER',
            waveColor: Colors.deepOrangeAccent,
            waveDuration: const Duration(seconds: 1),
            loadDuration: const Duration(seconds: 2),
            boxBackgroundColor: Color.fromRGBO(0, 84, 48, 1),
            textStyle: CustomTextStyles.textStyleExtraBold(
              fontSize: 40.0,
            ),
            boxHeight: 100.0,
          ),
        ],
      ),
    );
  }
}
