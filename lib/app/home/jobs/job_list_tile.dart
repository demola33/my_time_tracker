import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, this.onTap, @required this.job})
      : super(key: key);
  final VoidCallback onTap;
  final Job job;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      title: Text(
        job.name,
        style: CustomTextStyles.textStyleBold(fontSize: size.height * 0.025),
      ),
      trailing: Icon(Icons.chevron_right),
      dense: true,
      onTap: onTap,
    );
  }
}
