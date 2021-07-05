import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_icon_text_field.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

import '../models/job.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
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
  FocusNode _jobNameNode, _ratePerHourNode, _submitButtonNode;
  var _jobNameController = TextEditingController();
  var _jobRateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ratePerHourNode = FocusNode();
    _jobNameNode = FocusNode();
    _submitButtonNode = FocusNode();

    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
      _jobNameController = TextEditingController(text: _name);
      _jobRateController = TextEditingController(
          text: _ratePerHour != null ? '$_ratePerHour' : '');
    }
  }

  @override
  void dispose() {
    _ratePerHourNode.dispose();
    _jobNameNode.dispose();
    _submitButtonNode.dispose();
    super.dispose();
  }

  String get scaffoldContent {
    if (widget.job != null) {
      return '${widget.job.name} updated successfully.';
    } else {
      return '$_name added successfully.';
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

  void _jobNameEditingComplete() {
    FocusScope.of(context).requestFocus(_ratePerHourNode);
  }

  void _jobRateEditingComplete() {
    FocusScope.of(context).requestFocus(_submitButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          widget.job == null ? 'New Job' : 'Edit Job',
          style: CustomTextStyles.textStyleTitle(
              fontSize: size.height * 0.035, color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: true,
      ),
      body: _buildContent(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    Size size = MediaQuery.of(context).size;
    return [
      _buildJobNameField(),
      SizedBox(height: size.height * 0.02),
      _buildJobRateField(),
      SizedBox(height: size.height * 0.02),
      SizedBox(
        child: FormSubmitButton(
          onPressed: isLoading ? null : _submit,
          text: 'Save',
          focusNode: _submitButtonNode,
        ),
      ),
    ];
  }

  Widget _buildJobNameField() {
    return CustomIconTextField(
      labelText: 'Job name',
      icon: Icons.work,
      controller: _jobNameController,
      enabled: isLoading == false,
      validator: (value) =>
          value == null || value.isEmpty ? 'Name can\'t be empty' : null,
      focusNode: _jobNameNode,
      maxLength: 20,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) => _name = value,
      onEditingComplete: _jobNameEditingComplete,
    );
  }

  Widget _buildJobRateField() {
    return CustomIconTextField(
      labelText: 'Rate Per Hour',
      icon: Icons.attach_money,
      focusNode: _ratePerHourNode,
      enabled: isLoading == false,
      controller: _jobRateController,
      helperText: 'Rate must be an integer.',
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      textInputAction: TextInputAction.done,
      onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      onEditingComplete: _jobRateEditingComplete,
    );
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      setState(() {
        isLoading = true;
      });
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Job already exist',
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
          MyCustomSnackBar(
              enabled: widget.job == null ? true : false,
              text: scaffoldContent,
              onPressed: () => widget.database.deleteJob(job)).show(context);
        }
      } catch (e) {
        if (e.code == "permission-denied") {
          PlatformExceptionAlertDialog(title: 'Operation Failed', exception: e)
              .show(context);
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }
}
