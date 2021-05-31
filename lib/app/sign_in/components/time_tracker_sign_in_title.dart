import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerSignInTitle extends StatelessWidget {
  const TimeTrackerSignInTitle();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50.0,
      right: 50.0,
      top: MediaQuery.of(context).size.height / 8,
      child: SvgPicture.asset(
        'images/Time_tracker/2.svg',
        width: 500.0,
        height: 500.0,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => CircularProgressIndicator(),
      ),
    );
  }
}
