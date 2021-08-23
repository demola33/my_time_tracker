import 'package:my_time_tracker/app/home/jobs/customListBuilder.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/app/home/job_entries/entry_list_item.dart';
import 'package:my_time_tracker/app/home/job_entries/edit_entry_page.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/database.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class JobEntriesPage extends StatefulWidget {
  JobEntriesPage({@required this.database, @required this.job});

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

  @override
  _JobEntriesPageState createState() => _JobEntriesPageState();
}

class _JobEntriesPageState extends State<JobEntriesPage> {
  final Color uniqueJobsEntriesPageColor = Color.fromRGBO(0, 195, 111, 0.5);
  List<Entry> _allEntriesList = [];
  // ignore: unused_field
  Future<void> _resultLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resultLoaded = _getAllEntries();
  }

  Future<void> _getAllEntries() async {
    List<Entry> allEntries = await widget.database.entriesList(job: widget.job);
    setState(() {
      _allEntriesList = allEntries;
    });
  }

  void _navigateAndDisplayResult(BuildContext context, {Entry entry}) async {
    final result = await EditEntryPage.show(
        context: context,
        database: widget.database,
        job: widget.job,
        entry: entry);
    if (result == false) {
      _getAllEntries();
    }
  }

  Future<void> _confirmDelete(BuildContext context, Entry entry) async {
    final didRequestDelete = await PlatformAlertDialog(
      title: 'Delete',
      content: 'Would you like to delete this entry?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Delete',
    ).show(context);
    if (didRequestDelete == true) {
      _deleteEntry(context, entry);
      MyCustomSnackBar(
        //enabled: false,
        text: 'Entry removed successfully.',
      ).show(context);
    }
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    _allEntriesList.remove(entry);
    _getAllEntries();
    try {
      await widget.database.deleteEntry(entry);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: uniqueJobsEntriesPageColor,
        elevation: 5.0,
        title: Text(
          widget.job.name ?? 'Job name not found',
          style: CustomTextStyles.textStyleTitle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Entry',
            iconSize: 30.0,
            onPressed: () {
              _navigateAndDisplayResult(context);
            },
          )
        ],
      ),
      body: Container(
        color: uniqueJobsEntriesPageColor.withOpacity(0.1),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<List<Entry>>(
      future: widget.database.entriesStream(job: widget.job).first,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CustomListBuilder<Entry>(
            customList: _allEntriesList,
            scrollBarColor: uniqueJobsEntriesPageColor,
            itemBuilder: (context, int index) {
              Entry entry = _allEntriesList[index];
              return Slidable(
                key: Key('entry:${entry.id}'),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                    color: Colors.white,
                    child: EntryListItem(
                      entry: entry,
                      job: widget.job,
                    )),
                secondaryActions: [
                  IconSlideAction(
                      caption: 'Edit',
                      color: Colors.black45,
                      icon: Icons.edit,
                      onTap: () =>
                          _navigateAndDisplayResult(context, entry: entry)),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => _confirmDelete(context, entry),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
