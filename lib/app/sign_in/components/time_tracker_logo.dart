import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerLogo extends StatelessWidget {
  const TimeTrackerLogo();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50.0,
      right: 50.0,
      top: MediaQuery.of(context).size.height / 6,
      child: SvgPicture.asset(
        'images/Time_tracker/1.svg',
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => CircularProgressIndicator(),
      ),
    );
  }
}
