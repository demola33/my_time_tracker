import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeTrackerLogo extends StatelessWidget {
  const TimeTrackerLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.only(top: 60),
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
    // return Positioned(
    //   left: 50.0,
    //   right: 50.0,
    //   //height: 200.0,
    //   top: MediaQuery.of(context).size.height / 6,
    //   child: SvgPicture.asset(
    //     'images/Time_tracker/time_tracker_logo.svg',
    //     // width: 200.0,
    //     // height: 200.0,
    //     fit: BoxFit.cover,
    //     placeholderBuilder: (context) => CircularProgressIndicator(),
    //   ),
    // );
  }
}
