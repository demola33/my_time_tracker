import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

import 'job.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.job == null ? 'New Job' : 'Edit Job',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'SourceSansPro',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  InputDecoration _buildInputDecoration(
    String labelText,
    IconData icon,
    bool value,
  ) {
    Size size = MediaQuery.of(context).size;
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontFamily: 'SourceSansPro',
        fontWeight: FontWeight.bold,
        fontSize: size.height * 0.025,
      ),
      icon: Icon(
        icon,
        color: Colors.teal[700],
        size: size.height * 0.05,
      ),
      enabled: value,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(),
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.62,
              child: FormSubmitButton(
                onPressed: isLoading ? null : _submit,
                text: 'Save',
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      _buildJobNameField(),
      _buildJobRateField(),
      SizedBox(
        height: 15.0,
      )
    ];
  }

  Widget _buildJobNameField() {
    return TextFormField(
      decoration: _buildInputDecoration(
        'Job name',
        Icons.work,
        isLoading == false,
      ),
      initialValue: _name,
      validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) => _name = value,
    );
  }

  Widget _buildJobRateField() {
    return TextFormField(
      decoration: _buildInputDecoration(
        'Rate Per Hour',
        Icons.attach_money,
        isLoading == false,
      ),
      initialValue: _ratePerHour != null ? '$_ratePerHour' : '0',
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      onEditingComplete: _submit,
    );
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 5));
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Job Already Exist',
            content: 'Please use a different job name.',
            defaultActionText: 'Ok',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            id: id,
            name: _name,
            ratePerHour: _ratePerHour,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (e.code == "permission-denied") {
          FirebaseExceptionAlertDialog(title: 'Operation Failed', exception: e)
              .show(context);
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
