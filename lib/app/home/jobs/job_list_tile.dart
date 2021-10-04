import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

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
        job.name ?? 'Job name not found',
        style: CustomTextStyles.textStyleBold(fontSize: size.height * 0.025),
      ),
      subtitle: Text(
        job.organization,
        style: CustomTextStyles.textStyleBold(fontSize: size.height * 0.02),
      ),
      trailing: const Icon(Icons.chevron_right),
      dense: true,
      onTap: onTap,
    );
  }
}
