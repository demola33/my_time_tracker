import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerLogo extends StatelessWidget {
   const TimeTrackerLogo({Key key, this.topPadding = 60}) : super(key: key);
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          'images/Time_tracker/time_tracker_logo.svg',

          // height: 200.0,
          fit: BoxFit.contain,
          //placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
