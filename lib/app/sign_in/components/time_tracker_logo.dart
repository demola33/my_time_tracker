import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerLogo extends StatelessWidget {
  const TimeTrackerLogo({this.topPadding: 60});
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: ExcludeSemantics(
          child: SvgPicture.asset(
            'images/Time_tracker/time_tracker_logo.svg',

            // height: 200.0,
            fit: BoxFit.contain,
            //placeholderBuilder: (context) => CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
