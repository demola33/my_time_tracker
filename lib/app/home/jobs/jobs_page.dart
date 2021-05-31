import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:my_time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:my_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      FirebaseExceptionAlertDialog(
        exception: e,
        title: 'Signout failed',
      ).show(context);
    }
  }

  Future<void> _confirmLogOut(BuildContext context) async {
    final didRequestLogOut = await PlatformAlertDialog(
      title: 'Log Out',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestLogOut == true) {
      _signOut(context);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Job job) async {
    final didRequestDelete = await PlatformAlertDialog(
      title: 'Delete',
      content: 'Would you like to delete this job?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if (didRequestDelete == true) {
      _delete(context, job);
    }
  }

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } catch (e) {
      FirebaseExceptionAlertDialog(
        exception: e,
        title: 'Operation failed',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Jobs',
          style: CustomTextStyles.textStyleTitle(fontSize: size.height * 0.035),
        ),
        centerTitle: false,
        elevation: 10.0,
        actions: [
          TextButton(
            onPressed: () => _confirmLogOut(context),
            child: Text(
              'Log out',
              style: CustomTextStyles.textStyleTitle(
                  fontSize: size.height * 0.025),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _buildContents(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Slidable(
            key: Key('job:${job.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: JobListTile(
                job: job,
                onTap: () => JobEntriesPage.show(context, job),
              ),
            ),
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () => EditJobPage.show(context, job: job),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, job),
              ),
            ],
          ),
        );
      },
    );
  }
}
