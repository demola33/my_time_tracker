import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:my_time_tracker/app/home/job_entries/entry_list_item.dart';
import 'package:my_time_tracker/app/home/job_entries/entry_page.dart';
import 'package:my_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/services/database.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } catch (e) {
      FirebaseExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          job.name,
          style: CustomTextStyles.textStyleTitle(),
        ),
      ),
      body: _buildContent(context, job),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            EntryPage.show(context: context, database: database, job: job),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) => Slidable(
            key: Key('entry:${entry.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
                color: Colors.white,
                child: EntryListItem(
                  entry: entry,
                  job: job,
                )),
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () => EntryPage.show(
                  context: context,
                  database: database,
                  job: job,
                  entry: entry,
                ),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _deleteEntry(context, entry),
              ),
            ],
            //   return DismissibleEntryListItem(
            //     key: Key('entry-${entry.id}'),
            //     entry: entry,
            //     job: job,
            //     onDelete: () => _deleteEntry(context, entry),
            //     onEdit: () => print('entries'),
            //     onTap: () => EntryPage.show(
            //       context: context,
            //       database: database,
            //       job: job,
            //       entry: entry,
            //     ),
            //   );
            // }
          ),
        );
      },
    );
  }
}
