import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/job_entries/date_time_picker.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/app/sign_in/components/validators.dart';
import 'package:my_time_tracker/common_widgets/custom_text_field.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/common_widgets/true_or_false_switch.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class EditEntryPage extends StatefulWidget {
   const EditEntryPage({Key key,
    @required this.database,
    @required this.job,
    @required this.onSwitch,
    @required this.isConnected,
    this.entry,
  }) : super(key: key);
  final Job job;
  final Entry entry;
  final Database database;
  final TrueOrFalseSwitch onSwitch;
  final bool isConnected;

  static Future<bool> show(
      {BuildContext context,
      Database database,
      Job job,
      Entry entry,
      Format format}) async {
    final bool result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider<TrueOrFalseSwitch>(
            create: (_) => TrueOrFalseSwitch(),
            child: Consumer2<TrueOrFalseSwitch, ConnectivityProvider>(
              builder: (_, _onSwitch, _isConnected, __) => EditEntryPage(
                database: database,
                job: job,
                entry: entry,
                onSwitch: _onSwitch,
                isConnected: _isConnected.online,
              ),
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
    return result;
  }

  @override
  State<StatefulWidget> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _comment;
  FocusNode _commentFieldNode, _submitButtonNode;
  final _formKey = GlobalKey<FormState>();
  TrueOrFalseSwitch get onSwitch => widget.onSwitch;

  String get scaffoldContent {
    if (widget.entry != null) {
      return 'Entry updated successfully.';
    } else {
      return 'Entry added successfully.';
    }
  }

  @override
  void initState() {
    super.initState();
    _commentFieldNode = FocusNode();
    _submitButtonNode = FocusNode();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  @override
  void dispose() {
    _commentFieldNode.dispose();
    _submitButtonNode.dispose();
    super.dispose();
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
    bool undo;
    List<Entry> allEntries =
        await widget.database.entriesStream(job: widget.job).first;
    if (_formKey.currentState.validate()) {
      onSwitch.toggle();
      final entry = _entryFromState();
      if (widget.isConnected) {
        allEntries.add(entry);
        MyCustomSnackBar(
            text: scaffoldContent,
            onPressed: () {
              undo = allEntries.remove(entry);
            }).showPlusUndo(context).closed.whenComplete(() async {
          if (undo != true) {
            try {
              await widget.database.setEntry(entry);
            } catch (e) {
              undo = allEntries.remove(entry);
              onSwitch.toggle();
              PlatformExceptionAlertDialog(
                title: 'Operation failed',
                exception: e,
              ).show(context);
            }
          }
        }).then((value) {
          onSwitch.toggle();
          Navigator.of(context).pop(undo == true);
        });
      } else {
        onSwitch.toggle();
        MyCustomSnackBar(
          //enabled: false,
          text: 'No internet connection!',
        ).show(context);
      }
    }
  }

  void _commentEditingComplete() {
    FocusScope.of(context).requestFocus(_submitButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.teal),
        elevation: 0.0,
        title: Text(
          widget.job.name ?? 'Job name not found',
          style: CustomTextStyles.textStyleTitle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildBodyScrollView(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildBodyScrollView() {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildStartDate(),
                _buildEndDate(),
                SizedBox(height: height * 0.013),
                _buildDuration(),
                SizedBox(height: height * 0.013),
                _buildComment(),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: FormSubmitButton(
                      onPressed: onSwitch.value
                          ? null
                          : () => _setEntryAndDismiss(context),
                      text: widget.entry != null ? 'Update' : 'Create',
                      focusNode: _submitButtonNode,
                    ),
                  ),
                ),
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
      enabled: !onSwitch.value,
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectDate: (date) => setState(() => _startDate = date),
      onSelectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      enabled: !onSwitch.value,
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
    final durationFormatted = format.time(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Duration: ',
            style: CustomTextStyles.textStyleBold(color: Colors.teal[600]),
            children: [
              TextSpan(
                text: durationFormatted,
                style: CustomTextStyles.textStyleExtraBold(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComment() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: CustomTextField(
        focusNode: _commentFieldNode,
        labelText: 'Add a comment',
        enabled: !onSwitch.value,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        maxLength: 40,
        validator: CommentValidator(),
        controller: TextEditingController(text: _comment),
        onChanged: (comment) => _comment = comment,
        onEditingComplete: () => _commentEditingComplete(),
      ),
    );
  }
}
