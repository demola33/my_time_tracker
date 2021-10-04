import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerSignInTitle extends StatelessWidget {
   const TimeTrackerSignInTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SvgPicture.asset(
        'images/Time_tracker/time_tracker_title.svg',
        height: 100.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
