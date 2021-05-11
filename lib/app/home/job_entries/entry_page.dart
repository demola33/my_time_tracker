import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/job_entries/date_time_picker.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({
    @required this.database,
    @required this.job,
    this.entry,
  });
  final Job job;
  final Entry entry;
  final Database database;

  static Future<void> show(
      {BuildContext context,
      Database database,
      Job job,
      Entry entry,
      Format format}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, job: job, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } catch (e) {
      FirebaseExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
          widget.job.name,
          style: CustomTextStyles.textStyleTitle(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: CustomTextStyles.textStyleTitle(fontSize: height * 0.028),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: buildBodyScrollView(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget buildBodyScrollView() {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildStartDate(),
                _buildEndDate(),
                SizedBox(height: height * 0.013),
                _buildDuration(),
                SizedBox(height: height * 0.013),
                _buildComment(),
                SizedBox(height: height * 0.027),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectDate: (date) => setState(() => _startDate = date),
      onSelectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectDate: (date) => setState(() => _endDate = date),
      onSelectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final format = Provider.of<Format>(context);
    final currentEntry = _entryFromState();
    final durationFormatted = format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: CustomTextStyles.textStyleBold(color: Colors.teal),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    // return TextFormField(
    //   validator: (value) {
    //     print('exceeded');
    //     return (value.characters.length > 45) ? 'exceeded' : null;
    //   },
    //   keyboardType: TextInputType.text,
    //   maxLength: 45,
    //   controller: TextEditingController(text: _comment),
    //   decoration: InputDecoration(
    //     alignLabelWithHint: true,
    //     hintText: 'Leave a comment',
    //     hintStyle: CustomTextStyles.textStyleBold(),
    //     errorMaxLines: 1,
    //   ),
    //   style: CustomTextStyles.textStyleNormal(color: Colors.black),
    //   maxLines: null,
    //   onChanged: (comment) => _comment = comment,
    // );
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 45,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        // labelText: 'Comment',
        hintText: 'Leave a comment',
        hintStyle: CustomTextStyles.textStyleBold(),
      ),
      style: CustomTextStyles.textStyleNormal(color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
      onSubmitted: (email) => _check(email),
    );
  }

  _check(String email) {
    if (email.characters.length > 45) {
      print('Exceeded');
    }
  }
}
