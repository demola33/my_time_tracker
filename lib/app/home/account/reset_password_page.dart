import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/sign_in/components/password_field.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:my_time_tracker/common_widgets/form_submit_button.dart';
import 'package:my_time_tracker/common_widgets/show_snack_bar.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;
  FocusNode _currentPasswordNode, _newPasswordNode, _submitButtonNode;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isLoading = false;
  bool validate = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordNode = FocusNode();
    _newPasswordNode = FocusNode();
    _submitButtonNode = FocusNode();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.teal,
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(
          'Change Password',
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
            SizedBox(
              height: 15.0,
            ),
            _buildCurrentPassword(),
            SizedBox(
              height: 10.0,
            ),
            _buildNewPassword(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: FormSubmitButton(
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
      // errorText:
      //     checkCurrentPasswordValid ? null : 'Current password is invalid',
      autofocus: true,
      textInputAction: TextInputAction.next,
      onEditingComplete: _onCurrentPasswordEditingComplete,
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
    final auth = Provider.of<AuthBase>(context, listen: false);
    checkCurrentPasswordValid =
        await auth.validateCurrentPassword(_currentPasswordController.text);
    setState(() {});
    if (_formKey.currentState.validate()) {
      if (checkCurrentPasswordValid) {
        auth.updatePassword(_newPasswordController.text);
        Navigator.pop(context);
        MyCustomSnackBar(
          enabled: false,
          text: 'Password updated succesfully',
        ).show(context);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
