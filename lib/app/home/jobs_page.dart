import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/app/home/models/edit_job_page.dart';
import 'package:my_time_tracker/app/home/models/job_list_tile.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/services/auth.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(
        e.toString(),
      );
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

  // Future<void> _createJob(BuildContext context) async {
  //   print('no errors');
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.createJob(Job(name: 'Painting', ratePerHour: 30));
  //     print('finally done');
  //   } catch (e) {
  //     if (e.code == "permission-denied") {
  //       FirebaseExceptionAlertDialog(title: 'Operation Failed', exception: e)
  //           .show(context);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
          style: TextStyle(
            fontFamily: 'SourceSansPro',
            fontSize: 23.0,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 10.0,
        actions: [
          FlatButton(
            onPressed: () => _confirmLogOut(context),
            child: Text(
              'Log out',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
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
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => job).toList();
          // final children = jobs
          //     .map(
          //       (job) => JobListTile(
          //         job: job,
          //         onTap: () => EditJobPage.show(context, job: job),
          //       ),
          //     )
          //     .toList();
          // return ListView(
          //   children: children,
          // );
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) => Card(
              child: JobListTile(
                job: children[index],
                onTap: () => EditJobPage.show(context, job: children[index]),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
