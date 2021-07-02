import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:my_time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:my_time_tracker/services/auth_base.dart';
import 'package:provider/provider.dart';

import 'package:my_time_tracker/app/sign_in/components/password_field.dart';
import 'package:my_time_tracker/app/screens/email_sign_in_screen.dart';
import 'package:my_time_tracker/blocs/email_sign_up/email_sign_up_model.dart';
import 'package:my_time_tracker/common_widgets/cancel_and_next_button.dart';
import 'package:my_time_tracker/common_widgets/custom_icon_text_field.dart';
import '../components/already_have_an_account_check.dart';

class EmailSignUpFormChangeNotifierBased extends StatefulWidget {
  final EmailSignUpModel model;

  EmailSignUpFormChangeNotifierBased({
    Key key,
    this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignUpModel>(
      create: (_) => EmailSignUpModel(auth: auth),
      child: Consumer<EmailSignUpModel>(
        builder: (context, model, _) => EmailSignUpFormChangeNotifierBased(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignUpFormChangeNotifierBasedState createState() =>
      _EmailSignUpFormChangeNotifierBasedState();
}

class _EmailSignUpFormChangeNotifierBasedState
    extends State<EmailSignUpFormChangeNotifierBased> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _EmailSignUpFormChangeNotifierBasedState({this.onChanged});

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  final ValueChanged<bool> onChanged;
  EmailSignUpModel get model => widget.model;

  FocusNode _firstNameNode,
      _lastNameNode,
      _emailNode,
      _passwordNode,
      _retypePasswordNode,
      _signUpButtonNode;

  @override
  void initState() {
    super.initState();
    _firstNameNode = FocusNode();
    _emailNode = FocusNode();
    _lastNameNode = FocusNode();
    _passwordNode = FocusNode();
    _retypePasswordNode = FocusNode();
    _signUpButtonNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _emailNode.dispose();
    _lastNameNode.dispose();
    _passwordNode.dispose();
    _retypePasswordNode.dispose();
    super.dispose();
  }

  void _firstNameEditingComplete() {
    FocusScope.of(context).requestFocus(_lastNameNode);
  }

  void _lastNameEditingComplete() {
    FocusScope.of(context).requestFocus(_emailNode);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordNode);
  }

  _passwordEditingComplete() {
    FocusScope.of(context).requestFocus(_retypePasswordNode);
  }

  _confirmPasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_signUpButtonNode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    Size size = MediaQuery.of(context).size;

    return [
      SizedBox(height: size.height * 0.1),
      _buildFirstName(),
      SizedBox(height: size.height * 0.01),
      _buildLastName(),
      SizedBox(height: size.height * 0.01),
      _buildEmail(),
      SizedBox(height: size.height * 0.01),
      _buildPassword(),
      SizedBox(height: size.height * 0.02),
      _buildConfirmPassword(),
      //SizedBox(height: size.height * 0.01),
      CancelAndSignInButtons(
        focusNode: _signUpButtonNode,
        text: 'SIGN UP',
        onPressed: model.canSubmit ? _submit : null,
      ),
      //SizedBox(height: size.height * 0.01),
      AlreadyHaveAnAccountCheck(
        isMember: true,
        press: _routeToSignIn,
      ),
    ];
  }

  Widget _buildFirstName() {
    return CustomIconTextField(
      focusNode: _firstNameNode,
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (firstName) => model.updateWith(firstName: firstName),
      onEditingComplete: _firstNameEditingComplete,
      errorText: model.firstNameErrorText,
      icon: Icons.person,
      labelText: 'First Name',
      enabled: model.isLoading == false,
      hint: 'Adam',
    );
  }

  Widget _buildLastName() {
    return CustomIconTextField(
      focusNode: _lastNameNode,
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: (lastName) => model.updateWith(lastName: lastName),
      onEditingComplete: _lastNameEditingComplete,
      errorText: model.lastNameErrorText,
      icon: Icons.person,
      labelText: 'Last Name',
      enabled: model.isLoading == false,
      hint: 'Smith',
    );
  }

  Widget _buildEmail() {
    return CustomIconTextField(
      focusNode: _emailNode,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => model.updateWith(email: email),
      onEditingComplete: _emailEditingComplete,
      labelText: 'Email',
      hint: 'adamsmith@email.com',
      icon: Icons.email,
      errorText: model.emailErrorText,
      enabled: model.isLoading == false,
    );
  }

  Widget _buildPassword() {
    return PasswordField(
      focusNode: _passwordNode,
      reTypePassword: false,
      errorText: model.passwordErrorText,
      helperText: 'No more than 10 characters',
      passwordController: _passwordController,
      onChanged: (password) => model.updateWith(password: password),
      fieldKey: _passwordFieldKey,
      textInputAction: TextInputAction.next,
      maxLength: 10,
      enabled: model.isLoading == false,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildConfirmPassword() {
    return PasswordField(
      focusNode: _retypePasswordNode,
      reTypePassword: true,
      passwordController: _confirmPasswordController,
      textInputAction: TextInputAction.next,
      errorText: model.confirmPasswordErrorText,
      onChanged: (password) => model.updateWith(confirmPassword: password),
      enabled: model.isLoading == false,
      onEditingComplete: _confirmPasswordEditingComplete,
    );
  }

  Future<void> _routeToSignIn() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) {
          return EmailSignInPage();
        },
      ),
    );
  }

  // CheckboxListTile _checkboxListTile() {
  //   return CheckboxListTile(
  //     controlAffinity: ListTileControlAffinity.leading,
  //     value: model.agree,
  //     onChanged: (bool newValue) {
  //       model.updateWith(agree: newValue);
  //     },
  //     title: Text('Agree to terms and conditions',
  //         style: CustomTextStyles.textStyleBold()),
  //   );
  // }

  Future<void> _submit() async {
    ProgressDialog progressDialog = ProgressDialog(
      context: (context),
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Signing you up...',
    );
    progressDialog.show();

    try {
      await model.submit();
      Navigator.popUntil(context, (route) => route.isFirst);
    } on PlatformException catch (e) {
      progressDialog.dismiss();
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    }
  }
}
