import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/home/jobs/edit_job_page_manager.dart';
import '../../../common_widgets/custom_icon_text_field.dart';
import '../../../layout/custom_text_style.dart';
import '../../../common_widgets/form_submit_button.dart';
import '../../../common_widgets/platform_alert_dialog.dart';
import '../../../common_widgets/platform_exception_alert_dialog.dart';
import '../../../common_widgets/show_snack_bar.dart';
import '../../../common_widgets/true_or_false_switch.dart';
import '../../../services/connectivity_provider.dart';
import '../../../services/database.dart';
import '../models/job.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;
  final TrueOrFalseSwitch onSwitch;
  final bool isConnected;

  const EditJobPage({
    Key key,
    @required this.database,
    this.job,
    this.isConnected,
    @required this.onSwitch,
  }) : super(key: key);

  static Future<bool> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    final bool result = await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            Consumer2<TrueOrFalseSwitch, ConnectivityProvider>(
          builder: (context, _onSwitch, _isConnected, child) => EditJobPage(
            database: database,
            job: job,
            onSwitch: _onSwitch,
            isConnected: _isConnected.online,
          ),
        ),
      ),
    );
    return result;
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  EditJobPageManager get model => EditJobPageManager();
  final _formKey = GlobalKey<FormState>();
  TrueOrFalseSwitch get onSwitch => widget.onSwitch;

  String _name;
  String _organization;
  int _ratePerHour;
  FocusNode _jobNameNode,
      _ratePerHourNode,
      _organizationNode,
      _submitButtonNode;
  var _jobNameController = TextEditingController();
  var _organizationController = TextEditingController();
  var _jobRateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _ratePerHourNode = FocusNode();
    _jobNameNode = FocusNode();
    _organizationNode = FocusNode();
    _submitButtonNode = FocusNode();

    if (widget.job != null) {
      _name = widget.job.name;
      _organization = widget.job.organization;
      _ratePerHour = widget.job.ratePerHour;
      _jobNameController = TextEditingController(text: _name);
      _organizationController = TextEditingController(text: _organization);
      _jobRateController = TextEditingController(
          text: _ratePerHour != null ? '$_ratePerHour' : '');
    }
  }

  @override
  void dispose() {
    _ratePerHourNode.dispose();
    _jobNameNode.dispose();
    _organizationNode.dispose();
    _submitButtonNode.dispose();
    _jobNameController.dispose();
    _organizationController.dispose();
    _jobRateController.dispose();
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
    FocusScope.of(context).requestFocus(_organizationNode);
  }

  void _organizationEditingComplete() {
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
      _organizationField(),
      SizedBox(height: size.height * 0.02),
      _buildJobRateField(),
      SizedBox(height: size.height * 0.02),
      SizedBox(
        child: FormSubmitButton(
          onPressed: onSwitch.value ? null : _submit,
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
      enabled: !onSwitch.value,
      validator: model.firstNameValidator,
      focusNode: _jobNameNode,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) => _name = value,
      onEditingComplete: _jobNameEditingComplete,
    );
  }

  Widget _organizationField() {
    return CustomIconTextField(
      labelText: 'Organization',
      icon: Icons.business_sharp,
      controller: _organizationController,
      enabled: !onSwitch.value,
      validator: model.organizationNameValidator,
      focusNode: _organizationNode,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onSaved: (value) =>
          value != '' ? _organization = value : _organization = 'Freelance',
      onEditingComplete: _organizationEditingComplete,
    );
  }

  Widget _buildJobRateField() {
    return CustomIconTextField(
      labelText: 'Rate Per Hour',
      icon: Icons.attach_money,
      focusNode: _ratePerHourNode,
      enabled: !onSwitch.value,
      controller: _jobRateController,
      validator: model.jobRateValidator,
      helperText: 'Rate must be an integer.',
      keyboardType:
          TextInputType.numberWithOptions(decimal: false, signed: false),
      textInputAction: TextInputAction.done,
      onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      onEditingComplete: _jobRateEditingComplete,
    );
  }

  Future<void> _submit() async {
    bool undo;
    List<Job> allJobs = await widget.database.jobsList();
    if (_validateAndSaveForm()) {
      onSwitch.toggle();
      final jobs = allJobs;
      final jobNames = jobs.map((job) => job.name).toList();
      final jobOrganizations = jobs.map((job) => job.organization).toList();
      if (widget.job != null) {
        jobNames.remove(widget.job.name);
        jobOrganizations.remove(widget.job.organization);
      }
      if (jobNames.contains(_name) &&
          jobOrganizations.contains(_organization)) {
        PlatformAlertDialog(
          title: 'Job already exist',
          content: 'Please use a different job name.',
          defaultActionText: 'Ok',
        ).show(context);
        onSwitch.toggle();
      } else {
        final id = widget.job?.id ?? documentIdFromCurrentDate();
        final job = Job(
          id: id,
          name: _name,
          organization: _organization,
          ratePerHour: _ratePerHour,
        );
        if (widget.isConnected) {
          allJobs.add(job);
          await MyCustomSnackBar(
            text: scaffoldContent,
            onPressed: () {
              undo = allJobs.remove(job);
            },
          ).showPlusUndo(context).closed.whenComplete(() async {
            if (undo != true) {
              try {
                await widget.database.setJob(job);
              } catch (e) {
                undo = allJobs.remove(job);
                onSwitch.toggle();
                print('ERROR: ${e.toString()}');
                if (e.code == "permission-denied") {
                  PlatformExceptionAlertDialog(
                          title: 'Operation Failed', exception: e)
                      .show(context);
                }
              }
            }
          }).then((value) {
            onSwitch.toggle();
            Navigator.of(context).pop(undo == true);
          });
        } else {
          onSwitch.toggle();
          MyCustomSnackBar(
            text: 'No internet connection!',
          ).show(context);
        }
      }
    }
  }
}
