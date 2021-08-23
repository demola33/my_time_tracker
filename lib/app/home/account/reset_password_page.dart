import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/app/sign_in/components/password_field.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key key,
    @required this.auth,
    this.deleteAccount,
  }) : super(key: key);
  final bool deleteAccount;
  final AuthBase auth;

  static void show(BuildContext context, bool deleteAccount) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ResetPassword(
          auth: auth,
          deleteAccount: deleteAccount,
        ),
      ),
    );
  }

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;
  FocusNode _currentPasswordNode,
      _newPasswordNode,
      _submitButtonNode,
      _deleteButtonNode;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isLoading = false;
  bool validate = false;
  bool get deleteAccount => widget.deleteAccount;
  AuthBase get auth => widget.auth;

  @override
  void initState() {
    super.initState();
    _currentPasswordNode = FocusNode();
    _newPasswordNode = FocusNode();
    _submitButtonNode = FocusNode();
    _deleteButtonNode = FocusNode();
  }

  @override
  void dispose() {
    _currentPasswordNode = FocusNode();
    _newPasswordNode = FocusNode();
    _submitButtonNode = FocusNode();
    super.dispose();
  }

  void _onCurrentPasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_newPasswordNode);
  }

  void _onNewPasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_submitButtonNode);
  }

  void _onDeletePasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_deleteButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear_sharp),
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            await Future.delayed(Duration(milliseconds: 100));
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.teal,
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(
          deleteAccount ? 'Delete Account' : 'Change Password',
          style: CustomTextStyles.textStyleTitle(color: Colors.teal),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 30, right: 16, left: 16.0),
            color: Colors.white,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (deleteAccount)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Permanently delete your account and all of your content.',
                    style:
                        CustomTextStyles.textStyleExtraBold(color: Colors.red),
                  ),
                ),
              ),
            SizedBox(
              height: 15.0,
            ),
            _buildCurrentPassword(),
            SizedBox(
              height: 10.0,
            ),
            if (deleteAccount == false) _buildNewPassword(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: deleteAccount
                  ? FormSubmitButton(
                      onPressed: isLoading ? null : _delete,
                      text: 'Delete',
                      focusNode: _deleteButtonNode,
                    )
                  : FormSubmitButton(
                      onPressed: isLoading ? null : _submit,
                      text: 'Update password',
                      focusNode: _submitButtonNode,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPassword() {
    return PasswordField(
      passwordController: _currentPasswordController,
      focusNode: _currentPasswordNode,
      labelText: 'Current Password',
      enabled: isLoading == false,
      fillColor: Colors.black12,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password';
        } else if (!checkCurrentPasswordValid) {
          return 'Current password is invalid';
        }
        return null;
      },
      autofocus: true,
      textInputAction: TextInputAction.next,
      onEditingComplete: deleteAccount
          ? _onDeletePasswordEditingComplete
          : _onCurrentPasswordEditingComplete,
    );
  }

  Widget _buildNewPassword() {
    return PasswordField(
      passwordController: _newPasswordController,
      focusNode: _newPasswordNode,
      labelText: 'New Password',
      enabled: isLoading == false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your new password';
        } else if (_currentPasswordController.text == value) {
          return 'New password must be different from the current password';
        } else if (value.length < 10) {
          return 'Password can not be less than 10 characters';
        }
        return null;
      },
      fillColor: Colors.black12,
      textInputAction: TextInputAction.next,
      onEditingComplete: _onNewPasswordEditingComplete,
    );
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });
    checkCurrentPasswordValid =
        await auth.validateCurrentPassword(_currentPasswordController.text);
    setState(() {});
    if (_formKey.currentState.validate()) {
      if (checkCurrentPasswordValid) {
        auth.updatePassword(_newPasswordController.text);
        Navigator.pop(context);
        MyCustomSnackBar(
          text: 'Password updated successfully',
        ).show(context);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _delete() async {
    setState(() {
      isLoading = true;
    });
    checkCurrentPasswordValid =
        await auth.validateCurrentPassword(_currentPasswordController.text);
    setState(() {});
    if (_formKey.currentState.validate()) {
      if (checkCurrentPasswordValid) {
        // After deleting account, Set the current tab back
        // to the jobsPage
        HomeAppState.currentTab = 0;
        auth.deleteUserAccount();
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
