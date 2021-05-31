import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerSignInTitle extends StatelessWidget {
  const TimeTrackerSignInTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: ExcludeSemantics(
        child: SvgPicture.asset(
          'images/Time_tracker/time_tracker_title.svg',

          height: 100.0,
          fit: BoxFit.contain,
          //placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
